# Manifest Loader and Index: build-time + in-memory hybrid, two-pass validation, quarantine on failure

The Manifest Loader builds and maintains the Manifest Index, the canonical in-memory representation of all authored content. The Index is the foundation every other engine subsystem reads from: the Spatial Layer queries it for biomes and blocks, the Temporal Layer queries it for Sub-Factions and cultures, the Narrative Layer queries it for storylets and roles, the NPC runtime queries it for templates and drives. This ADR specifies how the Loader runs, what the Index contains, and how content updates propagate.

## Status

Accepted.

## Context

ADR-0003 locks the Manifest as a hybrid of Godot-native files and project-level JSON. ADR-0004 splits Entity Directories from Registry Files. ADR-0005 locks a flat root layout. ADR-0006 locks JSON Schema 2020-12 validation with a build-time Manifest Index. ADR-0014 separates authored instances from templates.

None of those ADRs specify *how the Loader actually runs*: load order, dependency resolution, hot-reload behavior, template-instance merge semantics, URN resolution rules, failure modes, or multiplayer Index sync. This ADR fills the gap.

## Considered Options

For each subsystem of the Loader, the alternatives considered:

- **D1 Load timing.** Pure build-time CLI; pure editor-time incremental; hybrid with in-memory as source of truth and build-time as packaging output. Hybrid selected.
- **D5 Template merge.** Shallow merge only; deep merge throughout; shallow default with schema-declared opt-in. Schema-declared opt-in selected.
- **D7 Index location.** Pure GDScript autoload; pure GDExtension/C++ native; autoload wrapper with GDExtension hot-path. Wrapper with GDExtension hot-path selected.
- **D8 Failure handling.** Hard fail on any error; load-everything-best-effort; quarantine with four severity tiers. Quarantine with four severity tiers selected.
- **D9 Multiplayer sync.** Re-validate per client; trust server entirely; hash-based version check at join. Hash-based version check selected.

## Decision

### D1. Build timing: hybrid, in-memory as source of truth

- **Editor and runtime work against an in-memory Manifest Index.** The Loader watches the filesystem and updates the Index on changed files. Both the agent and human authors edit through this surface.
- **A build-time CLI command (`engine build-manifest`) emits a binary Manifest Index artifact** (`manifest_index.bin`) for shipped builds. Shipped game binaries mmap this file at startup instead of walking the filesystem. The build artifact also carries the content hash used by D9 for multiplayer version checks.
- CI runs the build to produce the binary AND to confirm a strict-mode validation pass.

### D2. Load order: DAG by kind, with two-pass per phase

Load order:
1. **Schemas** (`schemas/*.schema.json` and `schemas/_common.schema.json`). Schemas validate each other (per JSON Schema 2020-12 meta-schema rules); failure here is fatal.
2. **Registry Files** (items, blocks, recipes, cultures, drives, roles, biomes, storylets, tool_calls, tesla_cores). Registries reference each other (recipes ↔ items, cultures ↔ biomes); forward references within this phase are allowed during pass 1, resolved in pass 2.
3. **Templates** (npc_templates, sub_faction_templates, wildlife_templates, station_templates). Templates reference registries.
4. **Authored Entity Directories** (npcs, sub_factions, settlements, bosses, artifacts, wildlife, stations, macro_factions). Authored instances reference templates and registries.
5. **world_gen.json** last. References everything.

Two passes per phase:
- **Pass 1 (Parse + structural validate).** Each file is parsed and validated against its schema. Forward references within a phase are permitted as opaque strings; cross-phase references are deferred entirely.
- **Pass 2 (Reference resolve).** After ALL phases complete pass 1, every URN reference in every loaded entity is resolved against the Index. Unresolved references become Hard Errors (D8 tier 2). Runtime URNs (typed as `RuntimeReferenceURN` per `_common.schema.json`) are explicitly skipped in this pass; the validator does not check them.

### D3. Manifest Index contents

The Index is a struct (C++ GDExtension class, surface GDScript) holding:

- `entries: HashMap<URN, IndexEntry>` where `IndexEntry { payload: Variant (parsed JSON), kind: StringName, source_path: String, schema_version: int, status: Loaded | Quarantined }`
- `by_kind: HashMap<StringName, Vec<URN>>` — inverse index for "give me all artifacts" style queries.
- `template_resolution_cache: HashMap<URN, Variant>` — for any authored instance with a `founding_template`, the fully-merged effective entity per D5. Computed lazily on first access, invalidated on edit.
- `schema_store: HashMap<schema_id, ValidatedSchema>` — the parsed schemas themselves, kept for runtime hot-reload validation.
- `content_hash: u64` — a hash over all `entries` payloads + schema_store. Updated on every successful edit. Used by D9 for multiplayer version checks.

### D4. Hot reload: filesystem watch, three edit flavors, quarantine on failure

Three flavors of edit are recognized:

- **Pure-data edit** (a field in an existing entity changed): re-validate the file against its schema, swap the Index entry payload, invalidate the template_resolution_cache entry if this entity is a template (cascade invalidation across instances), recompute `content_hash`, fire `content_reloaded(urn)` on the engine event bus.
- **Schema edit** (a schema file changed): re-validate every entity of that kind. Entities that no longer validate transition to `status: Quarantined`. The editor's validation panel shows the new errors. Entities that newly validate (because the schema relaxed) transition back to `Loaded`.
- **New entity added or deleted**: validate-and-insert or remove-and-update inverse indexes; deletions trigger reference-resolve on every entity that referenced the deleted URN (dangling references quarantine the referrer, not just emit an error).

The filesystem watcher debounces edits (~100ms) to avoid thrashing on multi-file saves and on the agent's bulk edits.

### D5. Template + instance merge: shallow default with schema opt-in

Default merge rule:
- Instance fields **replace** template fields wholesale at the top level. If an instance specifies a field, the template's value for that field is discarded entirely; no recursion.
- Instance does NOT need to specify all template fields. Unspecified fields inherit from the template directly.

Schema-declared opt-in:
- A schema property may carry `x-merge-strategy: deep` (object merge property-by-property) or `x-merge-strategy: union` (array union with dedup) or `x-merge-strategy: append` (array append, allow dupes).
- Examples where the opt-in makes sense: `tags` arrays (`union`), `combat_stats` objects where templates carry baseline and instances override specific stats (`deep`), `appearance` blocks (`deep`).
- Examples where shallow is correct: `drives` arrays (an instance with custom drives should not inherit template drives by accident), `recruitment_state` blocks (an authored Companion should not inherit template recruitment defaults silently).

The validator enforces `x-merge-strategy` is one of `shallow | deep | union | append`. Custom values are rejected at schema-load time.

### D6. URN resolution: four classes, distinct rules

- **Authored URN** (e.g., `sub_faction:aquilonia`): must resolve to a `Loaded` IndexEntry at pass-2 time, else Hard Error. Quarantined entries resolve syntactically but the engine refuses to instantiate from them at runtime.
- **Template URN** (e.g., `sub_faction_template:warring_kingdom`): must resolve to a `Loaded` IndexEntry of `kind = sub_faction_template`. The validator enforces type compatibility (`sub_faction:foo` is NOT interchangeable with `sub_faction_template:foo`).
- **Runtime URN** (e.g., `sub_faction:procgen_xyz_42`): pattern matches `_common.schema.json#/$defs/RuntimeReferenceURN`. Pass 2 explicitly skips these. The engine validates at runtime when the procgen system creates the referent.
- **Template Parameter** (e.g., `$sub_faction`, `$sub_faction.ruler`): pattern matches `_common.schema.json#/$defs/TemplateParameter` or `DotPathParameter`. Treated as opaque strings at load time; the storylet evaluator resolves at narrative-tick time. The Loader never tries to resolve these.

### D7. Index location: autoload + GDExtension hot path

- The Manifest Index lives as a `ManifestIndex` autoload registered by the fork itself (project authors do not register it).
- The autoload's class is GDScript for editor-facing surfaces (file paths, validation reports, edit triggers).
- The hot-path methods (URN lookup, by-kind iteration, template-merge resolution) are implemented in GDExtension C++ for performance. World generation and NPC tool-call resolution hit these millions of times per session.
- The GDExtension exposes a stable C++ ABI; project scripts use the GDScript wrapper, not the GDExtension directly.

### D8. Failure tiers: fatal, hard error, warning, info

- **Fatal**: schema files don't parse; `_common.schema.json` missing; the schema_store can't be constructed. Engine prints clear message and exits. The agent never sees a Fatal at runtime; this is only for build/CI surfaces.
- **Hard Error**: an entity fails its schema, or a URN reference doesn't resolve. The entity is marked `status: Quarantined` and is not instantiable. Engine still starts (so the agent can fix the problem from inside the editor). CI's `--strict` flag promotes Hard Errors to Fatal.
- **Warning**: deprecated field used, soft constraint violated, template-instance merge conflict that is allowed but suspicious. Logged. Entity still loads as `Loaded`.
- **Info**: load slower than threshold, entity size at the high end of expected range, etc. Debug-level only.

The validation panel UI shows Fatal in red-and-modal, Hard Error in red, Warning in yellow, Info hidden by default.

### D9. Multiplayer Index sync: hash-based version check at join

- Each client and the dedicated server compute `content_hash` over their Manifest Index.
- On client join, the server sends `content_hash` in the handshake. Client compares to its own.
- **Match**: join proceeds.
- **Mismatch**: client is refused with `content_version_mismatch` error; the error includes the server's hash and a diff URL (if the server is configured to serve a content-manifest-diff endpoint; off by default).
- Mods are part of content. A modded server requires clients to have the same mods loaded; mismatched mod content = mismatched hash = refused.
- The Event Log (per the upcoming Event Log ADR) is separate from the Index. The Event Log is runtime state; the Index is authored content. Sync rules differ.

## Consequences

- **The agent can iterate on content in real time inside the editor.** No rebuild required for any data edit. Schema edits trigger re-validation with quarantine, so the agent sees errors immediately and can fix forward.
- **Shipped builds boot fast.** The binary Manifest Index artifact is mmaped; no filesystem walk, no per-file parsing on cold start.
- **The Loader has a hard dependency on the schemas being correct.** A broken schema file is Fatal. This is a deliberate forcing function: bad schemas are caught at the earliest possible moment.
- **Quarantine semantics give the agent a working middle ground.** A project with three broken entities still starts; the broken ones are flagged, the rest of the game is playable. The agent can debug interactively rather than facing a "won't even start" wall.
- **Template merge is predictable.** Shallow default means the agent doesn't get confused by silent deep-merge surprises. Schema-declared opt-in means the schemas themselves document where the deep behavior happens.
- **Multiplayer is content-strict.** This is the right trade for an emergent-storytelling, deterministic-replay game. Content drift between clients = ruined simulation.
- **GDExtension is required.** The fork is no longer pure GDScript; the build pipeline must produce a GDExtension binary per platform. Acceptable given the agent-driven workload demands hot-path performance.
- **Filesystem watcher is a new dependency.** Cross-platform watching has gotchas (macOS FSEvents quirks, Linux inotify limits, Windows ReadDirectoryChangesW); standard library helpers exist in Godot's editor codebase that we should reuse rather than rolling our own.

## Out of scope

- The Event Log substrate (ADR-0009 says it exists; needs its own spec). Queued as next ADR.
- The agent's editor interface specifics (the surfaces the agent uses to invoke validation, request entities, watch for content_reloaded events). Queued.
- The save format. Closely related to the Event Log but distinct. Queued.
- The Asset Catalog integration. Closely related to the Manifest but the catalog lives outside the project (CC0 sources, license metadata, cache policy). Separate ADR.
- The actual GDExtension class layout in C++. Implementation detail; should be specified during prototyping not as ADR.
- The CLI command interface for `engine build-manifest` (flags, output paths, exit codes). Implementation detail.

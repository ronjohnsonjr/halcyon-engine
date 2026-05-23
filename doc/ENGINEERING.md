# Engine Project: Engineering Document

Status: working draft, updated as decisions crystallize in grilling sessions.

This document is the current consolidated engineering picture. It reflects findings from three prior research reports, the *Fractal Philosophy* technical analysis on procedural worlds and history simulation, and decisions made in direct grilling sessions. Each architectural choice is labeled `LOCKED` (confirmed in a grilling session and codified in an ADR or this document), `RECOMMENDED` (proposed by research, not yet challenged), or `OPEN` (deferred or still being grilled).

## 1. Overview

The Engine Project is a forked Godot 4.x **agentic engine for survival-genre games**. The flagship title is a steampunk-meets-cosmic-horror-meets-Hyborian-Age survival game with analog-tech progression (gears, steam engines, Tesla-punk, mechanical computing) and multi-world support via voidship travel between procedurally-generated planets, each populated with Hyborian-Age civilizations that the player's spacefaring civilization interacts with.

The engine is organized around a three-layer architecture (per ADR-0009): a **Spatial Layer** owning planetary representation (Goldberg hex-sphere planets with voxel chunks at player scale), a **Temporal Layer** owning the world tick and civilization simulation (Turchin/Khaldun structural-demographic dynamics, in-game LLM runtime for NPCs), and a **Narrative Layer** owning storylets and character memory. All three layers communicate via a shared append-only event log seeded by a single deterministic RNG.

The engine ships opinionated schemas for survival-genre concepts (mobs, blocks, recipes, biomes, world generation, items, crafting stations) and supports modding as a first-class concern (per ADR-0007). Non-survival genres are out of scope for MVP.

The agent's job at authoring time is to wire up game logic, scenes, game loops, mechanics, NPCs, recipes, schemas, and supporting scripts. Asset generation is explicitly out of scope; the agent works against a pre-indexed catalog of free and CC-licensed assets. At runtime, a separate in-game LLM runtime (Gemma 4 2B class, server-side authoritative per ADR-0008) drives NPC decisions.

See `CONTEXT.md` for the canonical glossary.

## 2. Operating Model

`LOCKED.` Open-source side project. No platform-operator infrastructure obligations. Public repo, permissively licensed. Self-hostable in every dimension: multiplayer servers, world hosting, asset catalog mirroring, and inference runtimes are all the creator's responsibility, not a managed-service obligation.

The plan keeps a graduation path open: if the project gains traction, it can become a funded product with managed hosting. No engineering decision should be made today that depends on that future.

`LOCKED.` Flagship-first generalization. The flagship Project Halcyon vertical slices prove engine needs before the engine extracts stable survival-framework abstractions. Build concrete Halcyon gameplay/editor workflows first, then generalize schemas, tools, and editor surfaces from demonstrated needs. Avoid generic engine abstractions that are not demanded by the flagship game or near-term survival-modder use.

## 3. Architecture

### 3.1 Engine Fork

`LOCKED.` Godot 4.x (targeting 4.4 LTS-style with the option to track 4.5+). MIT license. The fork modifies the editor (new panels for agent chat, manifest diff view, asset catalog browser, validation report, hex-sphere visualization, phase-plot debug for temporal-layer ODEs, storylet-trace UI), the runtime (vendored voxel runtime, hex-sphere subsystem, temporal-simulation subsystem, storylet manager, in-game LLM runtime, Manifest loader and validator, event-log substrate), and build targets (headless server build, web/WASM build with WebSocket transport).

Upstream Godot is otherwise left alone. The fork must be rebaseable against upstream releases quarterly.

### 3.2 Engine Scope

`LOCKED via ADR-0007.` Survival-genre framework with flagship game. The engine is opinionated about survival concepts and ships stable schemas for them. Modders can build other survival games using the same schemas. Non-survival genres are out of scope for MVP and may arrive in v1.0+ via a schema-pack architecture.

### 3.3 Three-Layer Architecture

`LOCKED via ADR-0009.` Spatial / Temporal / Narrative layers. Cross-cutting concerns (the Project Manifest, Scripts, the authoring-time agent, multiplayer) span all three.

```
                  CROSS-CUTTING
   +---------------------------------------+
   |  Project Manifest    (declarative)     |
   |  Scripts             (imperative)      |
   |  Authoring-Time Agent (Claude-Code)    |
   |  Multiplayer         (transports)      |
   +---------------------------------------+
              |        |        |
   +----------+--+  +--+-----+  +-+--------+
   |  Spatial   |  | Temporal|  | Narrative |
   |  (3.4)     |  | (3.5)   |  | (3.6)     |
   +------------+  +---------+  +-----------+
              |        |        |
   +---------------------------------------+
   |  Shared append-only event log         |
   |  Seeded RNG                            |
   +---------------------------------------+
```

### 3.4 Spatial Layer

`LOCKED via ADR-0010 (Goldberg sim overlay) and ADR-0017 (dual structure with cube-sphere voxel substrate).` Owns planetary representation and player-scale terrain. Three sub-components:

**Cube-sphere voxel substrate (player scale).** Each World's voxels live on a cube-sphere using the Adjusted Spherical Cube (ASC) projection: six face-local voxel grids, each clean and Minecraft-precision flat in its own frame. Player movement, building, mining, and combat happen here. The voxel runtime is a vendored fork of Zylann's `godot_voxel` (MIT) with modifications for per-face streaming and ASC projection in the generator stage. Voxel chunks are 32³ blocks (1m each). Depth uses a shell-based scheme (à la Blocky Planet / Jacco Bikker) that subdivides vertically toward the core to keep voxel proportions reasonable, with a hollow core below a minimum-radius shell.

**Goldberg hex-sphere sim overlay (planetary scale).** Each World carries a Goldberg G(4,0) hex sphere as a logical overlay: 162 hex tiles serving as the addressable unit for sub_faction ownership, biome assignment, storylet preconditions, and Turchin/Khaldun structural-demographic dynamics. The hex tiles are not voxel-storage units; they are queried via a lookup function `hex_id_of(voxel_position)` that returns the Goldberg tile containing a given point. The lookup table (~1 KB per cube face) is precomputed at world-gen via spherical Voronoi over the 162 hex centers.

**12 Pentagon Sites (unified topological singularities).** The cube-sphere and the Goldberg overlay are rotated so 8 cube corners coincide with 8 of 12 Goldberg pentagons. The remaining 4 pentagons fall on cube face centers. These 12 sites are first-class world features:

- **8 Corner Pentagons** = primary cosmic-horror eruption points. The 8 most geometrically distorted spots on the planet, presented in-fiction as the seams of reality where the void leaks through.
- **4 Face-Center Pentagons** = civilizational seed sites. Procedural sub_faction generation places the major cultures' founding sub_factions at these sites preferentially.
- All 12 are presented mechanically as **Wonder Regions**: distinct ambient lighting, weather, biome rules, and storylet eligibility. The geometric distortion is the gameplay/lore hook, not a bug.

`LOCKED.` Planet radius R = 6 km. Circumference ~37.7 km, ~7.5 hours to circumnavigate at walking speed. Each Goldberg hex tile covers ~2.8 km² (~1 km on a side). Each cube face covers ~75 km² (~8.7 km on a side, ~74,000 voxel chunks per face, ~444,000 surface chunks total). Approximate SQLite footprint: 1.2 GB per world (chunk data dominates; hex overlay is trivial).

`RECOMMENDED.` Asset pipeline: content-addressed local catalog with normalized glTF 2.0 outputs and `KHR_xmp_json_ld` metadata packets. First-tier sources: Kenney.nl, Quaternius, Poly Haven, Poly Pizza, ambientCG, Sketchfab CC0 filter, Freesound.

`OPEN.` Shell-based depth scheme parameters (shell count, subdivision rules, minimum core voxel size). Per-cube-face streamer architecture (six independent `VoxelTerrain` instances vs one custom multi-face streamer). Visual treatment of cube-edge kinks (shader seam-blend vs visible-but-explained). Wonder Region biome schema (extend existing biomes with override fields, or new biome category). Civilizational seed pentagon assignments (authored or procedural). Climate, erosion, hydrology (out of MVP scope; eventual additions on top of the Goldberg overlay).

### 3.5 Temporal Layer

`LOCKED via ADR-0009.` Owns the world tick at multiple cadences and runs the simulation systems on top of it.

**Tick cadences (planned).** Per ADR-0025, the engine runs a fixed tick and schedules game-time events on top of it rather than maintaining parallel clocks. State Vector updates use the multi-rate schedule from ADR-0020: Cohesion and Strain on game-day cadence, Reach and Martial Power on game-week cadence, and Mandate and Defensive Posture through legitimating or delegitimating events. Halcyon internal SubFactions tick faster because the player observes them constantly.

**SubFaction simulation.** Each SubFaction carries the 6-parameter Faction State Vector from ADR-0020: Cohesion, Reach, Mandate, Martial Power, Defensive Posture, and Strain. The Temporal Layer updates those values from scheduled events, player actions, Storyteller decisions, and culture-specific coefficients. Strain threshold crossings fire Strain Events with Resolution Windows. Output: Influence Zone changes, settlement conflicts, SubFaction birth/death/fragmentation/merge events, and State Vector deltas, all written to the event log.

**In-game LLM runtime.** `LOCKED via ADR-0008 (architecture), ADR-0011 (technical specifications), and ADR-0027 (provider strategy).` Server-side authoritative inference. Local/self-hosted is the default runtime target; optional remote runtime adapters are allowed in MVP only behind explicit server configuration and credentials. Remote adapters are server-only, disabled by default in sample projects, record request/response hashes and full outputs into the Event Log for replay, and expose latency/cost counters. Any remote-enabled MVP demo NPC must also have a local model profile and a scripted fallback path; if local inference is unavailable, it degrades to dialogue-plus-affinity flags rather than blocking gameplay. Runtime profile selection is stable per NPC session: selected at spawn/load from NPC content plus server config, with dynamic fallback but no gameplay profile switching. Drives NPCs (LLM-as-planner with scripted execution). Per ADR-0008, MVP ships D-architecture-B-content: two or three demonstration NPCs run the full planning loop; the rest run dialogue-plus-affinity-flags. Per ADR-0011, three-layer memory architecture (short-term in-prompt, mid-term summaries, long-term vector store), conversational latency budget <300ms, async-with-graceful-fallback mandatory, allowlist tool calls universal, NPC-to-NPC shared knowledge out of MVP.

`OPEN.` Tick scheduler implementation. State Vector update equations. Per-SubFaction vs per-culture coefficient assignment. Active-NPC set algorithm. Memory model for NPCs (vector + relational hybrid likely).

### 3.6 Narrative Layer

`LOCKED via ADR-0009.` Owns the Storylet registry, the Storylet evaluator, and character memory bindings. Versu/Façade lineage: not branching dialogue trees, but salience-driven storylet selection.

**Storylet evaluator.** Per narrative tick: filter storylets whose preconditions are satisfied; score them by salience (state-dependent); pick the highest-salience storylet per tier (Major, Minor, Flavor) respecting cooldowns; apply effects (which can mutate sim state); emit content.

**Character memory.** Each named NPC has bindings to events on the event log that touched their Hex Tile, their SubFaction, or them personally. When the player interacts with the NPC, the storylet pool is filtered by what that NPC knows.

`OPEN.` Storylet schema format (Entity Directory or Registry File). Salience function structure. Memory pruning / summarization. Authoring UX for storylets.

### 3.7 Cross-Cutting: Project Manifest

`LOCKED via ADRs 0003, 0004, 0005, 0006.` Hybrid of Godot-native files (`.tscn`, `.tres`, `project.godot`), per-entity directories (Entity Directories), and flat registry files (Registry Files). JSON Schema 2020-12 with build-time Manifest Index for cross-reference validation. Reference URN format: `<kind>:<id>` (e.g., `item:bone`, `tile:hex_4127`, `sub_faction:aquilonia`, `storylet:succession_crisis`).

MVP concept inventory: player (Entity Directory singleton), npcs/ (authored NPC instances, hybrid schema per ADR-0012, recruitment fields per ADR-0022), npc_templates/ (procgen NPC templates per ADR-0014), wildlife/ (Entity Directories, behavior-tree), wildlife_templates/, stations/ (Entity Directories), items.json + scenes/items/ (Registry File with optional scene references, gear category and drift_on_use per ADR-0022), blocks.json, recipes.json, biomes.json, world_gen.json (including cargo_manifest per ADR-0022), audio.json, roles.json (Registry File of stackable NPC trait bundles, per ADR-0012), storylets.json (Registry File with optional script and content references, per ADR-0013), macro_factions/ (Macro Faction Entity Directories per ADR-0019), sub_factions/ (authored SubFaction instances), sub_faction_templates/ (procgen SubFaction templates per ADR-0014), cultures.json (Registry File), tiles.json (per-World Registry File, generated, not hand-authored), artifacts/ (Resonance Web artifacts), tesla_cores.json, bosses/, and settlements/ per ADR-0021.

### 3.8 Cross-Cutting: Scripts

`LOCKED via ADR-0002.` GDScript files. The agent writes them freely with full filesystem access. No sandbox, no AST validator, no constrained "leaf behavior" concept. Auditability comes from the agent event log, git commits, and human review.

### 3.9 Cross-Cutting: Authoring-Time Agent

`LOCKED via ADR-0002, ADR-0024, and ADR-0026.` Claude-Code-style harness with engine-specific tools layered on the standard file/search surface. The engine supports an Agentic Engine Loop whose durable unit is an Agentic Run: a workflow-metadata record containing the goal, Permission Envelope, branch/worktree, plan, agent transcript, diffs, validation results, scene-test results, context provenance, relevant event-log excerpts, and acceptance status. Agentic Runs live under `.halcyon/runs/<run_id>/` by default and are ignored by template projects unless a team opts into tracking selected runs. Accepted-run commits include project changes by default; PR bodies carry run id, summary, gates, and key context citations, with absolute local paths redacted by default. Workflow metadata validates against `doc/schemas/workflow/`, separate from runtime Project Manifest validation. The `engine-agent` harness owns run metadata, Permission Envelope enforcement, gate orchestration, prompt harness execution, and commit/PR automation; the Godot editor Run Browser is a client of the local MCP/CLI API with run operations (`run_create`, `run_list`, `run_get`, `run_approve`, `run_cancel`, `run_resume`, `run_accept`, `run_reject`) and notifications. Chat-based run creation calls `run_create` under the hood. `run_create` compiles draft Permission Envelopes with deterministic heuristics plus schema, Context Pack, and path/URN lookup, and shows them for human approval before execution. During execution, writes are checked against the envelope, changed files are classified into surfaces, gates are recomputed from the actual diff, Reference URNs resolve through the Manifest Index, and sub-agent diffs merge through parent-owned review. Sub-agents always run inside the deterministic harness with child envelopes and their own evidence, even when self-hosted sub-agents may be spawned freely within policy. Run Browser blockers show concise summaries, failed gates, attempt counts, and recommended human action, with raw logs one click deeper. Authoring-Time Agents may autonomously modify project-level content inside a declared run; engine source, core schemas, Context Pack configuration, Provider Configuration, workflow schemas, permission defaults, ADR-level architecture, destructive migrations, and anything outside the run Permission Envelope remain human-gated by default. The Permission Envelope is structured for enforcement but should become natural-language friendly at the creator-facing UX layer. MVP scope is local-first: one primary Authoring-Time Agent per run, optional provider-sensitive sub-agents, run metadata, Run Browser, Permission Envelope, default gates, and project-specific Context Pack loading; hosted sync, multi-run task graphs, shared run templates, and rich timeline UI are deferred. Distinct from the in-game LLM runtime (ADR-0008), which is a separate subsystem.

`LOCKED via ADR-0027.` Provider strategy is split by subsystem. Authoring-Time Agents may use frontier APIs, subscription agents, self-hosted models, or hybrid routing depending on creator preference and task complexity. The in-game LLM runtime is optimized separately for deterministic replay, latency, cost, and server authority, with local/self-hosted as the default target and optional remote runtime adapters allowed in MVP.

### 3.10 Cross-Cutting: Multiplayer

`LOCKED via ADR-0001.` Authoritative dedicated server, self-hosted by creators. Luanti/Minetest topology. ENet (UDP) for desktop, WebSocket (WSS) for browser, same headless server process. SQLite persistence per World. The engine ships: `--headless --server` build, ENet and WebSocket transports, authoritative-server template with cheat-resistance scaffolding, SQLite chunk-and-entity persistence. The engine does not ship: managed lobby service, TURN/STUN relays, matchmaking, or hosted server VMs.

In-game LLM inference runs on the dedicated server. Single-player worlds run inference in the same process.

## 4. Flagship Title: Design Constraints

`OPEN (design constraints stated, not yet fully grilled).` Setting and core constraints:

- **Setting frame.** Victorian-Age / Tesla-punk space travelers crashland (Rimworld-style; cause: cosmic horror or "reasons") on a world that procedurally always has Hyborian-Age civilizations (or subsets). Cosmic horror is still in the mix; placement deferred.
- **Magic vs tech.** Asymmetric, not symmetric. Hyborian magic and Victorian/Tesla tech have different strengths and weaknesses (not balanced 1:1 across all axes). Specifics deferred to future grilling.
- **Player starting position.** Crashlanded. Some tech intact at the crash site, scavengeable. The game is "rebuild civilization on a magical alien world while surviving cosmic horror at the edges."
- **MVP playable scope.** Players are only from the spacefaring civilization at MVP. Playable Hyborian-civilization origin is a post-MVP extension.
- **Hyborian-Age civilization features.** All five aspirational (warring kingdoms with named rulers, decadent cities with named cultures, slave economies, sword-and-sorcery mysticism, religious factions), partially realized at MVP.
- **NPC disposition model.** Variable disposition (nice, hostile, neutral, depending on relationship), all killable, named NPCs do not respawn, all NPCs have persistent memory across sessions, factional alliance possible.
- **Difficulty profile.** Harder than vanilla Minecraft. Active survival (hunger, thirst, temperature, disease are candidates). Reference points: ARK: Survival Evolved, Vintage Story, modded Minecraft (Terrafirmacraft, GregTech-style progression).
- **Long-term scope.** Multi-world via voidship travel. Other worlds with different climates, civilizations, and cosmic-horror exposure. Out of MVP, but the spatial layer's Goldberg hex-sphere supports it natively.

Primary reference material:

- **Vintage Story** (canonical: cosmic-horror survival, deep crafting chains, temporal disturbances, knapping/clayforming/smithing tech tree).
- **Frostpunk** (cold survival + steampunk + societal collapse).
- **Sunless Sea / Sunless Skies** (Failbetter Games: Lovecraft + steampunk + StoryNexus quality-based narrative).
- **Conan Exiles** (Hyborian-Age survival without steampunk).
- **Arcanum: Of Steamworks and Magick Obscura** (steampunk + magic blending).
- **Rimworld** (crashlanded survival, settlement-building, narrative-as-emergence).
- **Bas-Lag novels by China Miéville** (literary reference for aesthetic synthesis).

## 5. Phased Plan

The original 11-month plan from the third research report assumed managed multiplayer hosting and platform infrastructure. With those out of scope and the Goldberg hex-sphere expanded into MVP, the timeline rebalances.

| Phase | OSS-adjusted | Notes |
|---|---|---|
| P0: Fork setup | 3 weeks | Unchanged. |
| P1: Asset ingestion pipeline | 4 weeks | Unchanged. |
| P2: Voxel runtime integration **+ Goldberg overlay** | 12-16 weeks | **Expanded.** Zylann fork integration, cube-sphere voxel substrate, Goldberg sim overlay, voxel-to-hex lookup, cube-edge visual treatment, sphere rendering. Largest single block of engineering. |
| P3: Single-player flagship MVP (hand-built) | 6 weeks | Unchanged. Hand-built reference on the hex-sphere; the agent later reproduces. |
| P4: Agentic Engine Loop MVP | 6 weeks | Local Agentic Runs, Permission Envelope enforcement, Run Browser, validation/scene-test integration, `.halcyon/runs/` metadata. |
| P5: Temporal layer (SubFaction simulation + in-game LLM runtime) | 6 weeks | **New.** Faction State Vector updates, Strain Event firing, LLM-as-planner subsystem, NPC memory store. |
| P6: Narrative layer (storylet manager) | 4 weeks | **New.** Storylet schema, evaluator, salience scoring, character memory bindings. |
| P7: Save/load and world persistence | 3 weeks | Unchanged. SQLite per World; persistence covers all three layers. |
| P8: Multiplayer milestone | 5 weeks | Unchanged from prior OSS adjustment. |
| P9: Browser deployment via WASM | 4 weeks | Unchanged. |
| P10: Polish and flagship MVP demo | 6 weeks | Unchanged. |

Total OSS-adjusted: approximately 59-63 weeks (about 14-15 months) versus the original 46 weeks. Side-project pace stretches this further. The relative ordering remains valid; P2 is now the longest single phase and dominates the critical path.

P4 provider scope: metadata and policy enforcement are in MVP, but only one configured authoring provider path needs to work end-to-end. True multi-provider routing is deferred until Agentic Runs, gates, and the Run Browser are solid.

P4 build order:

1. Workflow schemas and `.halcyon` metadata writer.
2. Permission Envelope enforcement.
3. Validation and scene-test gate integration.
4. Minimal Run Browser.
5. Accepted-run commit/PR automation.
6. 100-prompt Agentic Run harness.

P4 exit gate: 100/100 Halcyon-derived natural-language Agentic Run prompts reach `Ready For Review` with passing required gates and inspectable `.halcyon/runs/` evidence. Prompt fixtures live under `tests/agentic_runs/prompts/` and are schema-backed. Coverage quotas: 25 Manifest/content-only, 20 Script/system behavior, 15 scene/test, 15 storylet/narrative, 10 asset-binding, 10 Context Pack/design-grounded, 5 mixed high-risk. Each prompt records expected changed surfaces, gates, allowed context entries, and semantic success assertions; exact golden diffs are reserved for migration/formatting prompts. P5 exit gate: at least one SubFaction rises, strains, fragments, or collapses deterministically from a given seed, with the cycle visible in the editor's debug panel. P6 exit gate: storylets fire from temporal-layer events without authoring explosion. P8 exit gate: zero successful cheat exploits in red team.

## 6. Open Questions

Recently resolved (this session):

- ~~Manifest schema (broad)~~. ADRs 0003-0006.
- ~~Engine scope~~. ADR-0007.
- ~~NPC architecture~~. ADR-0008.
- ~~Three-layer architecture adoption~~. ADR-0009.
- ~~Spherical world commitment level~~. ADR-0010 (Goldberg from MVP).
- ~~Goldberg subdivision level / planet size at MVP~~. G(4,0), R=4km; folded into ADR-0010 / Section 3.4.
- ~~NPC subsystem technical specifications~~. ADR-0011.
- ~~NPC schema composability~~. ADR-0012 (hybrid structured fields plus freeform personality).
- ~~Storylet schema format~~. ADR-0013 (Registry File with optional script and content references).
- ~~Authored instances vs procedurally generated instances~~. ADR-0014 (separate concepts; authored instances in `npcs/`, `sub_factions/`; templates in `npc_templates/`, `sub_faction_templates/`).
- ~~SubFaction simulation state variables~~. ADR-0015 (4-variable Turchin model: N, S, W, E).
- ~~Coordinate frames on the hex-sphere~~. ADR-0016 (hybrid tile_id + tile-local offset).
- ~~Agentic Engine Loop / Agentic Run model~~. ADR-0026 (durable workflow metadata under `.halcyon/runs/<run_id>/`, Run Browser, Permission Envelope, quality gates, human acceptance).
- ~~Provider strategy split~~. ADR-0027 (Authoring-Time Agents can use hybrid provider routing; in-game LLM runtime optimizes separately for deterministic replay, latency, cost, and server authority, with local/self-hosted as default target and optional remote runtime adapters allowed in MVP).

Still open and queued for grilling:

- **Vertical extent per cube face.** Max depth below surface (shell-based depth scheme parameters: shell count, subdivision rules, minimum core voxel size). Max height above. Affects streaming budget.
- **SubFaction schema fields beyond simulation variables.** Authored-instance schema (id, culture, initial state, initial tiles, ruler, heir, named NPCs, per-sub_faction coefficients, lore). Template schema (typical state ranges, placement rules, count at world-gen, variability fields).
- **Role schema format.** Registry File `roles.json` is likely; pending grilling.
- **Per-cube-face streamer architecture.** Six independent `VoxelTerrain` instances vs one custom multi-face streamer. Engineering preference; deferred to P2.
- **Cube-edge kink visual treatment.** Shader seam-blend, geometry stitch, or visible-but-narratively-explained.
- **Wonder Region biome schema.** Extend existing biomes with override fields, or introduce a new biome category.
- ~~Civilizational seed pentagon assignments~~. Resolved by ADR-0018 (constraint-based procgen from eligibility-tagged pool; `culture.pentagon_eligibility` field plus `world_gen.pentagon_seeding` block; authored overrides via `pentagon_overrides`).
- **ADR-0018 schema implementation.** Add `pentagon_eligibility` field to `culture.schema.json`. Add `pentagon_seeding` block to `world_gen.schema.json`. Add optional `pentagon_seeding_template` to `sub_faction_template.schema.json`. Backfill eligibility tags on existing culture samples (karnish, veranthi, sethrai, arcadian, void_touched).
- **Zylann fork integration scope.** How much to fork vs wrap vs replace.
- **Voxel runtime confirmation.** Still RECOMMENDED, never grilled in isolation.
- **Asset pipeline details.** Source list, normalization, attribution generator are research recommendations; not grilled.
- **Provider routing details.** Exact provider adapters, model selection policy, local runtime target, and cost accounting for Authoring-Time Agents vs in-game LLM runtime.
- **Per-subsystem RNG splitting.** Deferred per ADR-0009; revisit before adding new subsystems.
- **Climate, erosion, hydrology.** Out of MVP; revisit for v1.0.
- **Hyborian civilization concrete shape at MVP.** Three procgen city-states? Static ruins of one named civ? Wandering tribes? All of the above with light implementation?
- **"System" pattern tunables location.** Day/night, hunger, health: scripts in `scripts/systems/`, tunables location per-tunable, not fully nailed.
- **Demo game distribution.** Bundled, hosted, or example-project source.
- **Engine fork license.** MIT, Apache 2.0, or dual-licensed.
- **Modding model details.** Distribution format, override semantics, dependency declarations.
- **Project name.** Working name pending.
- **Contribution model.** Governance, RFC process, code of conduct.

Resolved by recent ADRs (no longer open):

- ~~Seam handling at tile boundaries~~ → resolved by ADR-0017 (voxel substrate moves to cube-sphere; hex-tile seams no longer exist at voxel level; cube-edge seams handled per face).
- ~~Tile-to-chunk binding details~~ → resolved by ADR-0017 (chunks are cube-face-local 32³ voxel grids; no hex-tile binding needed).
- ~~Local gravity model~~ → resolved by ADR-0017 (gravity is per-cube-face-local; cube-sphere projection handles spherical curvature).
- ~~Cosmic horror placement~~ → resolved by ADR-0017 (8 Corner Pentagons host primary cosmic-horror sites; procgen may add minor sites).

## 7. Glossary

See `doc/CONTEXT.md`. Current terms cover: Project Manifest, Entity Directory, Authored Instance, Template, Registry File, Reference URN, Manifest Index, Authoring-Time Agent, Agentic Engine Loop, Agentic Run, Permission Envelope, Context Pack, Provider Configuration, Flagship-First Generalization, Script, World, Hex Tile, Macro Faction, SubFaction, Faction State Vector, NPC, Wildlife, Role, Drive, Storylet, Spatial Layer, Temporal Layer, Narrative Layer.

Retired terms: IR, Intermediate Representation, Spec, Blueprint, Plan, Leaf Behavior, Behavior Template, Manifest File (umbrella), Mob.

## 8. Decision Log

See `docs/adr/`. Current ADRs:

- `0001` Multiplayer is self-hosted dedicated server (Luanti/Minetest topology).
- `0002` Agent operates Claude-Code-style over Manifest + Script split.
- `0003` Manifest is a hybrid of Godot-native files and project-level JSON files.
- `0004` Folder-per-entity for instantiable concepts; flat Registry Files for pure-data tables.
- `0005` Flat root project layout; MVP inventory; items as Registry File.
- `0006` JSON Schema 2020-12 validation with build-time Manifest Index.
- `0007` Engine scope: survival-genre framework with flagship game (not generic).
- `0008` NPC architecture: LLM-as-planner with scripted execution; D-architecture, B-content at MVP.
- `0009` Adopt three-layer architecture: Spatial, Temporal, Narrative.
- `0010` Goldberg hex-sphere planet representation, from MVP.
- `0011` NPC subsystem technical specifications (memory, latency, async, allowlist, QA).
- `0012` NPC schema: hybrid structured fields with freeform personality.
- `0013` Storylet schema: Registry File with optional script and content references.
- `0014` Manifest supports authored instances and templates as separate concepts.
- `0015` SubFaction simulation uses 4-variable Turchin model (N, S, W, E). **Superseded by ADR-0020.**
- `0016` Coordinate frames on the hex-sphere: hybrid tile_id + tile-local offset.
- `0017` Dual spatial structure: cube-sphere voxels with Goldberg hex sim overlay. Twelve unified Pentagon Sites (8 cosmic-horror eruption corners + 4 civilizational seed centers). Planet radius R = 6 km.
- `0018` Pentagon Site seeding: constraint-based procgen from eligibility-tagged culture pool. Cultures declare `pentagon_eligibility` (founding, ruined, corrupt, frontier); world-gen samples from the pool with optional authored overrides.
- `0019` Terminology alignment with Project Halcyon design: polity becomes sub_faction; add macro_faction schema. Culture rename: cimmerian→karnish, aquilonian→veranthi, stygian→sethrai, spacefaring_arcadia→arcadian.
- `0020` Sub-Faction State Vector: 6-parameter model (Cohesion, Reach, Mandate, Martial Power, Defensive Posture, Strain) per the Project Halcyon design. **Supersedes ADR-0015.**
- `0021` Four new entity schemas for Project Halcyon content: artifacts (Resonance Web), tesla_cores (3 grades), bosses (5 tiers with Resolution Paths), settlements (Sub-Faction holdings).
- `0022` NPC recruitment fields (Resolve, Will, Loyalty, Suppression, Pathway, Coerced/Unwaveringly Loyal flags), item gear_category and drift_on_use, world_gen cargo_manifest block.
- `0023` Manifest Loader and Index: build-time + in-memory hybrid; two-pass validation per phase; template merge shallow-by-default with schema-declared deep/union/append opt-in; four-tier failure severity with quarantine; autoload + GDExtension hot path; hash-based multiplayer Index sync.
- `0024` Agent interface: claw-code-style harness (single binary, CLI + MCP server, slash-command REPL, 15-tool visible cap, Allow/Deny/Prompt permissions per-tool with cascading config). Engine-specific tools layered on inherited file/search surface. CLAUDE.md context loading and Skill tool inherited from claw substrate.
- `0025` Event Log: hybrid intent+delta events; in-memory ring + on-disk WAL + periodic snapshots; core events in code with mod events via Manifest schemas; deterministic simulation core with LLM outputs treated as inputs; server-authoritative multiplayer with client prediction; save format is genesis + snapshots + tail.
- `0026` Agentic Engine Loop: durable Agentic Runs as engine/workflow metadata under `.halcyon/runs/<run_id>/`; Run Browser editor surface with accepted-run commit/PR automation; autonomous over project-level content inside a declared Permission Envelope; engine source, core schemas, ADR-level decisions, and destructive migrations remain human-gated.
- `0027` Split provider strategy: Authoring-Time Agents use hybrid provider routing; in-game LLM runtime defaults local/self-hosted and is optimized separately for deterministic replay, latency, cost, and server authority.

## 9. Reference Documents

- **Research Report 1: Agentic AI Game Engines: Build vs Fork Analysis.** Recommendation: fork Godot 4.x.
- **Research Report 2: Agentic Engines Deep Dive (Voxel MVP Blueprint).** 11-month phased plan (now adjusted), asset pipeline, voxel runtime evaluation, multiplayer topology.
- **Research Report 3: Free/CC0 Asset Source Landscape** (within Report 2). Asset sources, license terms, API access.
- **Fractal Philosophy Technical Analysis** (Jacob O'Neill's YouTube channel, synthesized by external analysis). Three-layer architecture, Goldberg polyhedra for planet generation, Turchin/Khaldun structural-demographic theory with RK4 integration, storylet-based narrative architecture (Versu/Façade lineage). Adopted with MVP scoping per ADR-0009 and ADR-0010.
- **LLM-Driven NPCs: From Storybricks to Shipped Production Systems**. Survey of every shipped or seriously-demoed LLM-NPC system 2024-2026 (Where Winds Meet, Inworld, NVIDIA ACE, Convai, Mantella/Pantella, Replica, Project Sid). Establishes the universal LLM-as-planner-with-scripted-execution pattern, three-layer memory architecture, production latency budgets, allowlist tool-call convention, and known failure modes (Storybricks overscope, Replica cost). Informs ADR-0011.

When this document conflicts with the research reports or the Fractal Philosophy analysis, this document wins. Source documents stand as historical context.

---

End of working draft. Next grilling round: planet size and Goldberg subdivision level at MVP, because everything else in the spatial layer cascades from this number.

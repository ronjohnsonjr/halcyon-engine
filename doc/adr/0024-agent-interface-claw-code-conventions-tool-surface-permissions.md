# Agent interface: claw-code-style harness with engine-specific tools layered on the standard file/search surface

The fork ships an agent harness modeled on the claw-code architecture (clean-room Rust port of Claude Code patterns). The agent operates against the project as one binary providing CLI and MCP server entrypoints, exposing the standard file/search tool surface (`bash`, `read_file`, `write_file`, `edit_file`, `glob_search`, `grep_search`) plus engine-specific tools (`validate`, `index_query`, `scene_test`, `schema_describe`, `asset_catalog_search`). Permissions follow the Allow/Deny/Prompt model with per-tool policy. CLAUDE.md context loading and the Skill tool are inherited from the claw substrate.

## Status

Accepted.

## Context

ADR-0002 locked "agent operates Claude-Code-style over Manifest + Script split" as a one-line decision. ADR-0023 (the Manifest Loader) established what the agent works against. This ADR specifies the agent's actual surface: which tools it has, how it invokes them, how permissions work, how validation feedback flows back to the model, and how the agent stays in sync with hot-reloaded content.

The grilling for this ADR initially proceeded against guesses about Claude Code's patterns. Mid-grill, the canonical claw-code reference (a public Rust clean-room implementation of Claude Code's architecture at `github.com/ultraworkers/claw-code` with documentation at `claw-code.codes`) was identified as a more authoritative model than the guessing. The decisions below align with that reference rather than inventing parallel conventions.

## Considered Options

- **Invent a custom agent surface from scratch.** Rejected. Re-inventing tool conventions, permission semantics, MCP normalization, streaming event types, and session persistence loses years of shipped-product engineering for no upside. Agents written against Claude Code conventions would not transfer to the engine; nor vice-versa.
- **Wrap claw-code directly as a dependency.** Rejected for now. The fork's licensing and packaging would couple engine releases to claw-code releases. Reasonable to revisit if the dependency stabilizes.
- **Mirror claw-code's surface inside the fork.** Selected. Same tool naming, same permission model, same streaming event types, same CLAUDE.md discovery, same session persistence shape. Engine-specific tools layered on top as additional tool specs.

## Decision

### D1. Filesystem and indexed-API surfaces, both available

The agent uses the standard file/search tools (`bash`, `read_file`, `write_file`, `edit_file`, `glob_search`, `grep_search`) for creating and editing entity files, scripts, and schemas. The agent uses the engine-specific `index_query` tool for structured queries against the Manifest Index (by-kind, by-tag, by-reference, by-status). The filesystem remains the source of truth per ADR-0023; the indexed API exists because grepping 500 entity files to find every reference to `culture:karnish` is hostile to the agent.

### D2. Tool surface

The engine ships these tools alongside the inherited file/search baseline. Naming follows claw-code convention: snake_case for file/search and engine-data tools, PascalCase for higher-level orchestration tools.

| Tool | Naming style | Description |
| --- | --- | --- |
| `bash` | inherited | Sandboxed shell. Engine doesn't customize. |
| `read_file` | inherited | Offset + limit supported. |
| `write_file` | inherited | Overwrite. |
| `edit_file` | inherited | Targeted string replacement. |
| `glob_search` | inherited | Pattern-based file discovery. |
| `grep_search` | inherited | ripgrep regex content search. |
| `validate` | engine | Run the Manifest validator on a path, directory, or whole project. Returns structured errors (see D4). |
| `index_query` | engine | Structured query against the Manifest Index. Supports `kind=`, `tag=`, `references=`, `status=`. Returns URN list with source paths. |
| `schema_describe` | engine | Dump a schema in agent-readable form: required fields, types, enums, descriptions. Lets the agent ask "what fields does an artifact need?" without parsing the schema file. |
| `scene_test` | engine | Headless scene load and N-tick simulation. Returns summary: quarantines triggered, exceptions, determinism violations. |
| `asset_catalog_search` | engine | Search the CC0 asset catalog. Returns asset records with path, license, attribution, format, dimensions. |
| `Skill` | inherited | Invoke a registered skill module (grill-with-docs, future engine skills). |
| `Agent` | inherited | Spawn a sub-agent for parallel work. |
| `ToolSearch` | inherited | Search for deferred tools by keyword. |
| `TodoWrite` | inherited | Structured task list. |
| `StructuredOutput` | inherited | Return structured JSON response. |

The visible-tool cap is 15 per claw-code's `ToolPool`. The engine ships 14 above (6 inherited file/search + 5 engine-specific + 3 higher-level orchestration). Other inherited claw-code tools (`WebFetch`, `WebSearch`, `NotebookEdit`, `Sleep`, `SendUserMessage`, `Config`, `REPL`, `PowerShell`) remain available but may be deferred by the `ToolSearch` mechanism rather than always-visible.

`simple_mode` restricts the visible set to `bash`, `read_file`, `edit_file` per claw-code convention. The engine's CLI exposes a `--simple` flag that triggers this; useful for sandboxed CI runs and for agents that should only do small file edits.

### D3. CLI + MCP server, single binary

The fork ships one binary (working name `engine-agent`) providing both:

- **CLI entrypoint.** Slash-command REPL (`/help`, `/status`, `/compact`, `/model`, `/permissions`, `/clear`, `/cost`, `/resume`, `/config`, `/memory`, `/init`, `/exit`, `/diff`, `/version`, `/export` from the claw-code set, plus engine-specific commands as needed). Built on `crossterm`, `syntect`, `pulldown_cmark` per the claw-code stack. Direct invocation: `engine-agent prompt "..."`.
- **MCP server entrypoint.** Exposes the same tools through MCP protocol. Name normalization is `mcp__engine__<tool>` per the `mcp__{server}__{tool}` convention. Transport types supported: Stdio, SSE, HTTP, WebSocket per claw-code.

The CLI is the durable surface. The MCP server is a wrapper that lets non-engine-CLI agents (Claude Code itself, Cursor, other MCP clients) integrate. If MCP evolves, the CLI keeps working.

### D4. Structured validation output

The `validate` tool returns `StructuredOutput`-style responses, one entry per violation. Format:

```json
{
  "severity": "fatal | hard_error | warning | info",
  "urn": "boss:sundered_hold",
  "source_path": "samples/bosses/sundered_hold/data.json",
  "field": "/resolution_paths/0/prerequisites",
  "schema_constraint": "type: array",
  "got_value": "string",
  "message": "Expected an array of strings; got a single string.",
  "suggested_fix": {
    "kind": "wrap_in_array",
    "patch": [{"op": "replace", "path": "/resolution_paths/0/prerequisites", "value": ["..."]}]
  }
}
```

`severity` matches the four tiers from ADR-0023. `field` is a JSON Pointer per RFC 6901. `suggested_fix.patch` is JSON Patch per RFC 6902 when a fix is computable; absent when not. Common failure modes get fix suggestions (forgot to wrap in array, used a deprecated field name, typo in enum value with edit-distance < 3). Anything more complex: structured info without a patch.

### D5. Permission model: Allow / Deny / Prompt, per-tool, cascading config

Adopted directly from claw-code:

- `PermissionMode` enum: `Allow | Deny | Prompt`.
- `PermissionPolicy` is per-tool. Each tool has a default mode; users override via `settings.json` at User, Project, or Local level.
- `PermissionDenial` is a typed event flowing through the streaming surface (see D7), not a string error.

Engine-specific defaults:

| Tool | Default mode | Rationale |
| --- | --- | --- |
| `bash` | Prompt | Arbitrary command execution; user confirms each call. |
| `read_file`, `glob_search`, `grep_search` | Allow | Read-only; cheap; agent uses heavily. |
| `write_file`, `edit_file` | Allow | The agent's main work. Permission denied at the schema/quarantine layer if the file is invalid (per ADR-0023). |
| `validate`, `index_query`, `schema_describe` | Allow | Read-only against the Manifest. |
| `scene_test` | Allow | Runs headlessly; sandboxed at the engine level. |
| `asset_catalog_search` | Allow | Read-only against the catalog. |
| Core-schema edit (any `edit_file` targeting `schemas/_common.schema.json` or other ADR-locked schemas) | Prompt | Special-cased. The validator detects the target and forces a prompt regardless of the underlying tool's mode. |

CI runs use a `--allow-all` flag promoting all `Prompt` defaults to `Allow` with the assumption that CI itself is the gating mechanism.

### D6. Test surfaces

Three test surfaces, all invokable by the agent and run automatically in CI:

- **Validation tests.** The `validate` tool itself, run on the whole project. CI's `--strict` flag promotes Hard Errors to Fatal. Required to pass on every PR.
- **Scene tests.** The `scene_test` tool loads a Godot scene headlessly, runs N deterministic ticks, asserts no quarantines triggered, no exceptions, no determinism violations against a previous run's recorded Event Log (per the upcoming Event Log ADR).
- **Schema fixture tests.** Every schema has a `samples/<kind>/<id>/data.json` known-good fixture AND a `tests/<kind>/<id>/bad_data.json` known-bad fixture. CI enforces good passes and bad fails. Catches schema regressions where a constraint relaxed by accident. The `coverage_audit` tool (modeled on claw-code's `parity_audit.py`) reports gaps in fixture coverage.

### D7. Event subscription via streaming surface

The agent subscribes to the standard 6-event streaming surface inherited from claw-code: `message_start`, `command_match`, `tool_match`, `permission_denial`, `message_delta`, `message_stop`. The engine adds 4 content-change event types to the same surface:

- `content_reloaded(urn)` — entity payload changed after a successful re-validation.
- `content_added(urn)` — new entity inserted into the Index.
- `content_removed(urn)` — entity removed; references to it now dangle.
- `quarantine_added(urn, errors[])` / `quarantine_cleared(urn)` — entity moved into or out of `Quarantined` status.

The MCP server exposes these as MCP notifications. The CLI shows them inline in the REPL (yellow text for content changes; red for quarantines). The agent uses them to refresh its understanding when the human author (or another agent) edits content.

### D8. Multi-agent collaboration

The `Agent` tool (inherited from claw-code) spawns a sub-agent for parallel work. The engine does NOT implement operational-transform or CRDT-style merge for concurrent edits. Multiple agents and human authors coordinate at the git level: filesystem-level race conditions resolve last-write-wins; rollback is `git revert`.

### D9. CLAUDE.md context loading

The fork ships an `engine/CLAUDE.md` skeleton populated with engine-specific context: URN format, ADR style, schema conventions, the grilling pattern, the validation expectations, the loader semantics from ADR-0023. The Rust prompt module (inherited from claw-code) discovers and assembles this with `MAX_INSTRUCTION_FILE_CHARS = 4000` and `MAX_TOTAL_INSTRUCTION_CHARS = 12000`.

Project authors populate their own `CLAUDE.md` at the project root for game-specific context (the project's flagship game's setting, conventions, ongoing arcs). Both load. Both fit within the inherited character limits.

### D10. Engine skills in claw skill format

The engine ships skills in `engine/skills/` invokable through the inherited `Skill` tool:

- **grill-with-docs** — the architecture-grilling skill that produced this session's ADRs. Already authored.
- **manifest-validate** — guided validation walkthrough for new authors.
- **scene-test-author** — scaffolds a scene test from a target entity.
- **asset-catalog-query** — guided asset search and license verification.
- Future engine skills as content authoring patterns crystallize.

Project authors add their own skills in `<project>/skills/`. Both directories are discovered by the Skill tool.

## Consequences

- **The fork is no longer a standalone Godot patch.** It now includes a separate `engine-agent` binary, a Rust workspace for that binary, and integration with the Godot editor for surfacing agent activity. Build pipeline complexity increases substantially.
- **Agent tooling tracks claw-code (and by extension Claude Code) conventions.** When those evolve, the engine has work to do to track them. Acceptable cost; the alternative is reinventing harder.
- **MCP integration means the engine is usable from non-engine clients.** A developer using Claude Code or Cursor can connect to the engine's MCP server and edit project content through their existing agent. This is a big developer-experience win.
- **Permissions are properly modeled.** No more "the agent host handles it" hand-wave. Per-tool Allow/Deny/Prompt with cascading config gives the agent clear semantics and the user real control.
- **Core schema edits are gated.** The Prompt-by-default for `_common.schema.json` and ADR-locked schemas prevents an agent from silently breaking the foundation. The user has to explicitly approve.
- **CLAUDE.md is the engine's onboarding surface for the agent.** Whatever lives there is what every agent session starts with. Worth treating as a first-class artifact, updated when ADRs land.
- **The 15-tool visible cap forces discipline.** Adding a 16th engine tool means demoting one of the existing visible tools to deferred (`ToolSearch`-loaded) status. This is a forcing function against tool bloat.

## Out of scope

- The `engine-agent` Rust workspace layout (crates, dependencies, build config). Implementation detail.
- The Godot editor integration that surfaces agent activity (the panels mentioned in ENGINEERING.md section 3.1). Closely related but a separate ADR.
- Token budget tuning for engine workloads. claw-code defaults (`max_turns=8`, `max_budget_tokens=2000`, `compact_after_turns=12`) inherit; we revisit if engine-specific patterns show different optimal values.
- The Event Log substrate that determinism tests rely on. Queued as the next ADR per the spec roadmap.
- The asset catalog format and CC0 metadata schema. Separate ADR.

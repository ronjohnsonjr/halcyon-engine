# P4 Implementation Brief: Agentic Engine Loop MVP

Status: handoff brief, derived from ADR-0026 and the current engineering plan.

## Goal

Build the local-first Agentic Engine Loop MVP. The durable unit is an Agentic Run owned by `engine-agent`, displayed and controlled by the Godot editor Run Browser, and persisted as workflow metadata under `.halcyon/runs/<run_id>/`.

## Scope

P4 includes:

- Workflow schemas under `doc/schemas/workflow/`.
- `.halcyon/context_pack.json` and Context Pack loading.
- `.halcyon/runs/<run_id>/` metadata writing.
- `run_create`, `run_list`, `run_get`, `run_approve`, `run_cancel`, `run_resume`, `run_accept`, and `run_reject` operations on the local MCP/CLI surface.
- Permission Envelope compilation and enforcement.
- Deterministic execution checks during runs.
- Validation and scene-test gate orchestration.
- Minimal Run Browser.
- Accepted-run commit/PR automation.
- 100-prompt Agentic Run acceptance harness.

Deferred:

- Hosted run sync.
- Multi-run task graphs.
- Marketplace/shared run templates.
- Rich timeline UI.

## Build Order

1. Workflow schemas and `.halcyon` metadata writer.
2. Permission Envelope enforcement.
3. Validation and scene-test gate integration.
4. Minimal Run Browser.
5. Accepted-run commit/PR automation.
6. 100-prompt Agentic Run harness.

## Deterministic Harness Rules

- `run_create` compiles draft Permission Envelopes with deterministic heuristics plus schema, Context Pack, and path/URN lookup.
- Every write is checked against the Permission Envelope.
- Every changed file is classified into a changed surface.
- Required gates are recomputed from the actual diff before `Ready For Review`.
- Reference URNs resolve through the Manifest Index.
- Sub-agents always run inside the harness with child envelopes and their own evidence.
- Sub-agent diffs merge only through parent-owned review.
- Default gate repair budget is two autonomous attempts per gate category.

## Acceptance Set

P4 exits when 100/100 Halcyon-derived natural-language Agentic Run prompts reach `Ready For Review` with passing gates and inspectable `.halcyon/runs/` evidence.

Prompt fixtures live under `tests/agentic_runs/prompts/` and validate against `doc/schemas/workflow/agentic_run_prompt.schema.json`.

Coverage quotas:

- 25 Manifest/content-only runs.
- 20 Script/system behavior runs.
- 15 scene/test runs.
- 15 storylet/narrative runs.
- 10 asset-binding runs.
- 10 Context Pack/design-grounded runs.
- 5 mixed high-risk runs.

Assertions are semantic and gate-based by default. Exact golden diffs are reserved for migration or formatting prompts.

## Human-Gated Defaults

The following require explicit human approval by default:

- Engine fork source.
- Core schemas.
- Context Pack configuration.
- Workflow schemas.
- Permission defaults.
- ADR-level architecture.
- Destructive migrations.
- Anything outside the run Permission Envelope.

## Git And PR Policy

`Mark Accepted` creates a local commit and opens a PR when a remote exists. If PR creation fails after the commit succeeds, the run remains `Accepted`, records the blocker, and offers a retry action.

Accepted-run commits include project changes by default, not full `.halcyon/runs/<run_id>/` metadata. PR bodies include run id, summary, gates, and key context citations. Absolute local paths are redacted by default.

## Open Implementation Details

- Exact Rust crate/module layout for the workflow schemas and metadata writer.
- Exact MCP/CLI request and response shapes for run operations.
- How the editor subscribes to run event notifications.
- Minimal Run Browser layout.
- Prompt harness execution environment and fixture runner command.

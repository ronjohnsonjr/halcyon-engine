# Agentic Engine Loop: durable Agentic Runs as workflow metadata

The engine treats autonomous agent work as a first-class engine capability, not just an external chat workflow. This ADR extends ADR-0024's agent harness/tool-surface decision with a durable **Agentic Run** model that the editor can display, resume, cancel, audit, and promote into normal git review.

## Status

Accepted.

## Context

ADR-0024 specified the agent interface: a claw-code-style harness, inherited file/search tools, engine-specific validation/query/test tools, permission policy, streaming events, and multi-agent spawning. That described how an agent talks to the project, but not the unit of autonomous work the engine owns.

The design goal is broader than "Cursor or Claude Code can edit this repo." Halcyon should support agentic development from idea to implementation to validation: agents plan, modify Manifest content and Scripts, run validation and scene tests, inspect results, and iterate until acceptance criteria are met. That loop needs a durable object for editor UX, auditability, cancellation, resume, and future CI/PR integration.

The decision also has to preserve the boundary between two different uses of AI:

- **Authoring-Time Agent**: the development-time co-developer operating over project content and tests.
- **In-game LLM runtime**: the gameplay subsystem that drives NPCs at runtime.

Those remain separate systems.

## Considered Options

- **Option A: Durable Agentic Runs as engine/workflow metadata.** Selected. Gives the editor and CLI a concrete unit to show, resume, cancel, audit, and promote without polluting game content.
- **Option B: Ordinary chat sessions only.** Rejected. Chat sessions are not enough for long-running autonomous work: they do not naturally bind a goal, permissions, diffs, validation results, scene-test output, and acceptance state into one inspectable unit.
- **Option C: Full task graph/DAG from the start.** Rejected for now. Multi-step orchestration will matter later, but making the first durable unit a DAG would front-load scheduler complexity before the engine has proven the simpler run model.
- **Option D: Git branch/commit/PR as the only durable unit.** Rejected. Git is the review and history substrate, but it does not capture validation attempts, scene-test excerpts, permission envelopes, or agent/sub-agent transcripts without a parallel metadata model.
- **Option E: Put Agentic Runs in the Project Manifest.** Rejected. Runs are workflow records about changing game content, not game content. Treating them as Manifest state would make validation, runtime builds, and modding semantics confusing.
- **Option F: External database only.** Rejected. External storage may be useful for hosted or managed products later, but the open-source/self-hostable operating model needs local, inspectable, git-trackable metadata.

## Decision

### D1. The Agentic Engine Loop is first-class

The engine supports an **Agentic Engine Loop**: one or more Authoring-Time Agents can design, edit, validate, test, inspect results, and iterate on game project changes. This loop is part of the engine/editor product surface, not merely an external IDE convention.

The loop operates over project-level content:

- Project Manifest data.
- Entity Directories.
- Registry Files.
- Scripts.
- Scenes.
- Tests and fixtures.
- Validation output.
- Scene-test output.
- Asset catalog query results.
- Event-log excerpts relevant to test/debug work.
- Project-specific Context Packs.

The loop remains distinct from the in-game LLM runtime. Sharing implementation utilities is allowed where useful, but the product concepts and authority boundaries are separate.

The engine provides the Context Pack mechanism: Authoring-Time Agents load engine/tooling vocabulary plus project-specific glossary, design, convention, and skill files during Agentic Runs. The flagship Project Halcyon fiction and game-design assumptions live in the project Context Pack, not in generic engine behavior.

Context Packs are discovered through an explicit project manifest:

```text
.halcyon/context_pack.json
```

The context pack manifest lists project glossary, design, convention, and skill files. New projects get sensible starter defaults. The engine may suggest additions from conventional paths such as `doc/CONTEXT.md`, `doc/game-design/`, `CLAUDE.md`, and project skills, but the approved manifest is the source of truth. Agentic Runs do not broadly ingest every project document by default.

The manifest validates against `doc/schemas/workflow/context_pack.schema.json`.

Context Packs may also list explicit external `reference_roots`, such as a local game-design archive outside the repo. Reference roots are read-only. Agentic Runs may search them for context, but they are not edited, not validated as project content, and not required for builds.

Each Agentic Run records context provenance: Context Pack version/hash, concrete files loaded, external reference roots searched, and key source citations used for decisions. Runs do not snapshot full copies of every context file by default.

Workflow metadata validates against schemas under `doc/schemas/workflow/`: `agentic_run.schema.json`, `permission_envelope.schema.json`, `run_context.schema.json`, and `context_pack.schema.json`. These schemas are separate from runtime Project Manifest schemas and are not part of game-content validation.

### D2. Agentic Run is the durable unit of autonomous work

An **Agentic Run** records:

- Goal.
- Permission Envelope.
- Working branch or worktree.
- Plan.
- Agent and sub-agent transcript.
- Manifest, Script, scene, and test diffs.
- Validation results.
- Scene-test results.
- Context provenance.
- Estimated and actual provider usage when available.
- Relevant event-log excerpts.
- Final acceptance status.

The editor and CLI treat an Agentic Run as the thing that can be displayed, resumed, cancelled, audited, accepted, and promoted into git review.

Agentic Run lifecycle:

```text
Draft -> Approved -> Running -> Blocked | Failed | Ready For Review -> Accepted | Rejected | Cancelled
```

`Ready For Review` means the agent believes the run satisfies its validation and test gates. `Accepted` is always a human decision, not an automatic consequence of passing gates. When a human marks a run `Accepted`, the Run Browser creates a local commit and, when a remote exists, opens a pull request that references the run id. If PR creation fails after the commit succeeds, the run remains `Accepted`, records the PR blocker, and offers a retry action.

`Blocked` means the run needs a human decision or capability outside the Permission Envelope: approval to touch gated files, missing credentials, an unavailable external reference root, ambiguous requirements, or repeated gate failure with multiple plausible fixes. `Failed` means the harness or agent hit an implementation, tool, or runtime error it cannot recover from without changing code/tooling.

Budget exhaustion is `Blocked`, not `Failed`. Each Agentic Run records estimated and actual spend/usage when the provider exposes it. Self-hosted runs record resource/time usage rather than dollar spend. The Run Browser shows current budget consumption.

### D3. Agentic Runs are workflow metadata, not Manifest content

Agentic Run records are stored as engine/workflow metadata outside the Project Manifest. They may reference Manifest URNs and file paths, but they do not validate as game content and do not ship into runtime builds.

The metadata should be local and inspectable. It should be possible for a creator to git-track selected runs for auditability, but run records are not required to be committed for the game to build or run.

### D4. Default write authority

Within a declared Agentic Run, Authoring-Time Agents may autonomously modify project-level content:

- Manifest data.
- Entity Directories.
- Registry Files.
- Scripts.
- Scenes.
- Tests.
- Generated fixtures.

The following remain human-gated by default:

- Engine fork source.
- Core schemas.
- Context Pack configuration.
- Provider Configuration.
- Workflow schemas.
- Permission defaults.
- ADR-locked architecture.
- Destructive migrations.
- Any operation outside the run's Permission Envelope.

This extends ADR-0024's per-tool permission model with a run-level boundary. Tool-level Allow/Deny/Prompt still applies inside the run.

### D4a. Permission Envelope shape

Each Agentic Run has a **Permission Envelope**. The creator-facing UX should be natural-language friendly, but the engine enforces a structured envelope compiled from that intent.

The structured envelope contains:

- Allowed paths or Reference URN kinds.
- Allowed tool categories.
- Forbidden operations.
- Max spend, time, and turn budgets.
- Required gates.
- Human-gated paths.
- Provider/cost class for the run.
- Sub-agent policy.

Early implementations may expose the structured fields directly. As the platform matures, the editor should let users express the envelope in plain language and show the compiled structure before approval.

Sub-agent policy is provider-sensitive:

- **Self-hosted agents** may spawn sub-agents freely within the parent Permission Envelope.
- **Frontier/API/subscription-cost agents** require explicit sub-agent allowance.

All sub-agents stay inside the deterministic harness. Each sub-agent receives a child Permission Envelope, emits its own transcript and evidence, and cannot write directly to the parent branch unless the parent merges its diff through the same checks. Sub-agents should avoid concurrent edits to the same file set unless the parent serializes or merges the work.

### D5. Git remains the review substrate

Agentic Runs do not replace git. They produce diffs and evidence. Git branches, commits, and pull requests remain the durable review and collaboration surface.

The expected flow is:

1. Creator starts or approves an Agentic Run with a goal and Permission Envelope.
2. The run operates in a branch or worktree.
3. The run iterates until validation and test criteria are satisfied or it reports a blocker.
4. The creator accepts, rejects, or resumes the run.
5. Accepted runs create a local commit and, when a remote exists, open a pull request that references the run id.
6. If PR creation fails after a successful commit, the run records the blocker and offers a PR retry action.

### D6. Local storage convention

By default, Agentic Runs are stored under:

```text
.halcyon/runs/<run_id>/
```

The run directory contains structured files rather than an opaque database:

- `run.json` for goal, Permission Envelope, status, branch/worktree, timestamps, and summary.
- `transcript.jsonl` for agent and sub-agent transcript events.
- `validation.json` for Manifest validation attempts and final result.
- `scene_tests.json` for scene-test attempts and final result.
- `context.json` for Context Pack version/hash, concrete files loaded, external reference roots searched, and key source citations used for decisions.
- `event_log_excerpt.jsonl` for event-log evidence relevant to the run.
- `diff.patch` for the final diff or latest accepted diff snapshot.

Template projects ignore `.halcyon/runs/` by default to avoid noisy commits. Accepted-run commits include the actual project, code, or documentation changes by default, not the full run directory. The generated PR body includes the run id, summary, gate results, and key context citations. Absolute local paths are redacted from PR bodies by default: PR text uses repo-relative paths or labels like "external reference root: Project Halcyon design archive." Full local paths remain in local run metadata. Teams may opt into tracking selected run directories when they want audit evidence in git.

### D7. Default quality gates

An Agentic Run can mark itself `Ready For Review` only after the gates required by its changed surface pass:

- **Content-affecting runs**: Manifest validation must pass.
- **Schema-changing runs**: schema fixture tests must pass.
- **Scene or Script runs**: relevant scene tests must pass.
- **Runtime simulation runs**: deterministic replay/event-log checks must pass.
- **Documentation-only runs**: documentation link and format checks are sufficient.

The Permission Envelope may add stricter gates. It may not silently remove the defaults for the changed surface unless a human explicitly approves the weaker envelope.

During execution, the harness enforces deterministic checks:

- Every write is checked against the Permission Envelope.
- Every changed file is classified into a changed surface.
- Required gates are recomputed from the actual diff before a run can enter `Ready For Review`.
- Reference URNs are resolved through the Manifest Index.
- Sub-agent outputs merge only through parent-owned diff review.

Gate repair policy defaults to two autonomous repair attempts per gate category. After that, if multiple plausible fixes remain or the next fix would widen the Permission Envelope, the run becomes `Blocked` with the failed gate evidence. The Permission Envelope may set stricter repair budgets.

### D8. Run Browser editor surface

The `engine-agent`/claw-style harness owns Agentic Run workflow logic: run metadata, Permission Envelope enforcement, gate orchestration, prompt harness execution, and accepted-run commit/PR automation. The Godot editor exposes Agentic Runs through a **Run Browser** that acts as a client of the engine-agent API.

The Run Browser talks to `engine-agent` through the local MCP/CLI server surface from ADR-0024. ADR-0026 adds run-oriented operations and notifications to that surface rather than creating a private editor-only protocol:

- `run_create`
- `run_list`
- `run_get`
- `run_approve`
- `run_cancel`
- `run_resume`
- `run_accept`
- `run_reject`
- run event notifications for status, gate, blocker, and git/PR changes

`run_create` is the canonical creation path. It accepts a natural-language goal plus optional structured Permission Envelope hints, compiles a draft Permission Envelope, writes a `Draft` run, and waits for human approval before execution. Chat-based run creation calls `run_create` under the hood rather than maintaining a separate chat-only creation path.

Permission Envelope compilation is deterministic-first. MVP compilation uses heuristics plus schema, Context Pack, and path/URN lookup to infer changed surfaces, candidate paths or Reference URN kinds, default gates, provider/cost class, and human-gated paths. The compiled envelope is shown for approval and can be edited before `run_approve`. LLM suggestions may help explain or propose an envelope, but the harness verifies them through deterministic checks rather than trusting model output directly.

The Run Browser prioritizes:

- Run status.
- Goal.
- Permission Envelope.
- Diff.
- Gate results.
- Transcript.
- Blockers.
- Review and control actions: `Approve`, `Cancel`, `Resume`, `Mark Accepted`, `Reject`.

For blockers and failed gates, the Run Browser shows a concise top-level blocker summary, the exact failed gate or gates, attempted fix count, and the smallest recommended human action. Raw logs and transcripts stay one click deeper.

This is the primary editor surface for autonomous development work. Chat remains useful for conversation, but accepted/rejected work is reviewed through the Run Browser. `Mark Accepted` creates the git commit and opens a pull request when a remote exists. If PR creation fails after the commit succeeds, the run stays `Accepted`, records the blocker, and surfaces a retry action.

### D9. MVP scope

The Agentic Engine Loop MVP is local-first:

- Local Agentic Runs.
- One primary Authoring-Time Agent per run.
- Optional provider-sensitive sub-agents.
- `.halcyon/runs/<run_id>/` metadata.
- Run Browser review surface.
- Project-content autonomy inside a Permission Envelope.
- Default quality gates.
- Project-specific Context Pack loading.

The MVP defers hosted run sync, multi-run task graphs, marketplace/shared run templates, and rich timeline UI.

The P4 acceptance set is 100 natural-language Agentic Run prompts derived from concrete Project Halcyon vertical slices. Prompt fixtures live under `tests/agentic_runs/prompts/`, one JSON file per prompt, validated by `doc/schemas/workflow/agentic_run_prompt.schema.json`. The set covers Manifest-only edits, Script edits, scene/test edits, storylet changes, asset binding, and Context Pack usage. Each prompt records expected changed surfaces, required gates, allowed context entries, and success assertions. Success means every run reaches `Ready For Review` with passing gates and inspectable `.halcyon/runs/` evidence.

Coverage quotas for the 100-prompt set:

- 25 Manifest/content-only runs.
- 20 Script/system behavior runs.
- 15 scene/test runs.
- 15 storylet/narrative runs.
- 10 asset-binding runs.
- 10 Context Pack/design-grounded runs.
- 5 mixed high-risk runs.

Prompt assertions are semantic and gate-based by default. They assert required behavior, allowed changed surfaces, resolved Reference URNs, and passed gates. Exact golden diffs are used only for tasks whose point is an exact migration or formatting change.

P4 build order:

1. Workflow schemas and `.halcyon` metadata writer.
2. Permission Envelope enforcement.
3. Validation and scene-test gate integration.
4. Minimal Run Browser.
5. Accepted-run commit/PR automation.
6. 100-prompt Agentic Run harness.

## Consequences

- **Editor UX needs a Run Browser.** The editor needs a panel or equivalent surface for active and historical Agentic Runs, including status, goal, Permission Envelope, diff, validation/test evidence, transcript access, blockers, review/control actions, and accepted-run commit/PR automation surfaced through the `engine-agent` API.
- **Run metadata becomes part of the engine workspace model.** The engine writes local workflow metadata under `.halcyon/runs/<run_id>/`, even though the records are not Manifest content.
- **Accepted-run commits stay focused.** Run evidence is summarized in PR bodies by default; full run metadata is committed only by team opt-in.
- **ADR-0024 is extended, not replaced.** The claw-code-style harness and permission model remain the tool substrate. ADR-0026 defines the autonomous work unit layered above that substrate.
- **Core architecture and future-agent configuration stay protected.** Agents can move quickly on game/project content, but engine source, core schemas, Context Pack configuration, Provider Configuration, workflow schemas, permission defaults, ADR-level decisions, and destructive migrations retain explicit human approval.
- **Game design remains project-specific.** The engine formalizes Context Pack loading, but Project Halcyon fiction and other game-specific assumptions stay in project docs and skills rather than generic engine code.
- **Future orchestration can build on runs.** Task graphs, multi-run campaigns, CI agents, and hosted automation can compose Agentic Runs later without changing the base unit.

## Out of scope

- Detailed Run Browser visual layout.
- Multi-run task graph scheduling.
- Hosted product storage or synchronization of run history.
- Marketplace or shared Agentic Run templates.

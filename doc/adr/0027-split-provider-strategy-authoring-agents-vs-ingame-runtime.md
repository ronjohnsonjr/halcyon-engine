# Split provider strategy for Authoring-Time Agents and in-game LLM runtime

Authoring-Time Agents and the in-game LLM runtime use separate provider strategies. Authoring-time work may route to frontier APIs, subscription agents, self-hosted models, or hybrid setups depending on creator preference and task complexity. The in-game runtime is optimized separately for deterministic replay, latency, cost, and server authority, with local/self-hosted as the default target.

## Status

Accepted.

## Context

Earlier ADRs deliberately separated two AI surfaces:

- ADR-0002 and ADR-0024 define the Authoring-Time Agent surface: a development-time co-developer operating over the Project Manifest, Scripts, files, validation, tests, and engine-specific tools.
- ADR-0008 and ADR-0011 define the in-game LLM runtime: a server-authoritative gameplay subsystem driving NPC planning and dialogue.
- ADR-0025 treats LLM outputs as recorded inputs for deterministic replay.
- ADR-0026 adds Agentic Runs, Permission Envelopes, provider/cost class, and provider-sensitive sub-agent policy.

The old open question treated "LLM provider choice" as one combined decision. That is the wrong shape. Authoring-time work and runtime NPC inference have different constraints:

- Authoring-time work values quality, deep reasoning, code understanding, broad context, and optional expensive bursts.
- Runtime NPC inference values latency, predictable cost, server authority, offline/self-hostable operation, and deterministic replay via recorded outputs.

## Considered Options

- **Option A: Split provider strategy by subsystem.** Selected. Lets each AI surface optimize for its real constraints while preserving the conceptual boundary between development-time agents and runtime NPCs.
- **Option B: Use the same provider stack for both.** Rejected. A provider good for code/design work may be too slow, costly, or non-self-hostable for NPC runtime inference. A small local runtime model may be insufficient for heavy authoring work.
- **Option C: Frontier APIs by default for both.** Rejected. Good quality, but poor default fit for self-hostable runtime, offline play, predictable server cost, and deterministic replay workflows.
- **Option D: Local/self-hosted only for both.** Rejected. Strong self-hosting story, but unnecessarily constrains authoring-time agents where users may willingly pay for frontier quality or already have subscription access.

## Decision

### D1. Authoring-Time Agents use hybrid provider routing

Authoring-Time Agents may use:

- Frontier APIs.
- Subscription-based coding agents.
- Self-hosted models.
- Hybrid routing by task type, cost budget, and user preference.

The Permission Envelope records provider/cost class. Sub-agent policy is provider-sensitive per ADR-0026:

- Self-hosted agents may spawn sub-agents freely within the parent Permission Envelope.
- Frontier/API/subscription-cost agents require explicit sub-agent allowance and child envelopes.

Authoring-time provider routing remains a workflow concern. It is not part of runtime game determinism.

Each Agentic Run records estimated and actual spend/usage when the provider exposes it. The Run Browser shows budget consumption. Budget exhaustion blocks the run for human action rather than marking it failed. Self-hosted authoring runs record resource/time usage instead of dollar spend.

### D2. In-game LLM runtime defaults local/self-hosted

The in-game LLM runtime defaults toward local/self-hosted inference because runtime NPC behavior needs:

- Server authority.
- Predictable cost.
- Low latency.
- Offline/self-hostable operation.
- Deterministic replay by recording LLM outputs as inputs per ADR-0025.

Remote runtime providers may be supported as optional MVP adapters, but the default target remains local/self-hosted.

### D3. Determinism boundary differs by subsystem

Authoring-Time Agents are audited through Agentic Run metadata, git diffs, validation gates, scene tests, and human review. Their model calls do not need runtime determinism.

The in-game runtime must preserve deterministic replay. Live LLM responses are recorded as event-log inputs; replay uses recorded responses rather than re-querying the provider.

### D4. Exact providers and adapters are deferred

This ADR decides the strategy split, not the specific provider list. Exact adapters, model names, local runtime target, routing policy, and cost accounting are implementation details for later design and testing.

### D4a. Provider configuration location

Non-secret provider preferences live in `.halcyon/provider_config.json`, validated by `doc/schemas/workflow/provider_config.schema.json`. Secrets and credentials live outside the repo in user/server configuration or environment variables. Context Packs remain knowledge/configuration for agent context, not provider configuration.

Provider Configuration owns named in-game runtime profiles. NPC content references a profile id or uses the runtime default, and declares behavior tier/fallback requirements. NPC schemas do not carry provider credentials, hardware details, or adapter configuration directly.

Provider Configuration also carries the MVP validation cap for full-planning NPCs, defaulting to 3. This cap is enforced by runtime/content validation, not baked into the NPC schema. Exceeding the cap is a warning in development validation and a hard error for release/export validation.

Runtime profile selection is static for MVP sessions. The engine selects an NPC's runtime profile at spawn/load from NPC content plus server configuration, and that profile stays stable for the NPC during the session. Fallback mode may activate dynamically when inference fails, but profile switching is not a gameplay mechanic yet.

### D5. P4 authoring-provider MVP

P4 implements provider/cost metadata and policy enforcement, but only needs one configured authoring provider path working end-to-end. True multi-provider routing is deferred until Agentic Runs, gates, and the Run Browser are solid.

### D6. In-game runtime MVP adapters

The in-game LLM runtime MVP defaults to local/self-hosted inference but may include optional remote runtime adapters. Optional remote adapters must preserve the ADR-0025 replay boundary by recording provider outputs as event-log inputs. Remote adapters are not required for offline/self-hosted operation.

Remote runtime adapter guardrails:

- Server-only; clients never call runtime providers directly.
- Disabled by default in sample projects.
- Require explicit server configuration and credentials.
- Record request/response hashes and full outputs into the Event Log for replay.
- Expose latency and cost counters.
- Provide local/self-hosted fallback behavior for demo content.

For MVP demo content, any NPC that can use a remote adapter must also have:

- A local model profile.
- A scripted fallback path.

If local inference is unavailable, the NPC degrades to the dialogue-plus-affinity-flag behavior from ADR-0008 rather than blocking gameplay.

## Consequences

- **One provider decision becomes two.** Engineering docs and Agentic Run metadata must distinguish authoring-time provider routing from runtime NPC inference.
- **Cost policy is clearer.** Expensive frontier calls can be acceptable for authoring-time bursts while runtime NPC costs stay bounded by local/self-hosted defaults.
- **Provider configuration is separated from knowledge context.** Context Packs describe what agents should know; provider config describes how agents and runtime adapters connect.
- **Offline and self-hostable runtime stays protected.** The gameplay loop does not depend on a managed AI provider by default, even if optional remote adapters are present.
- **Agentic Run sub-agent policy has a provider basis.** Self-hosted sub-agents can fan out more freely; paid providers stay explicitly budgeted.
- **Runtime replay remains compatible with remote providers.** Optional remote runtime providers can exist because replay consumes recorded outputs, but live server cost/latency remains a project/server choice.

## Out of scope

- Choosing exact authoring-time providers.
- Choosing exact in-game runtime model families.
- Provider adapter API shape.
- Cost accounting UI.
- Model download, quantization, and hardware requirements for local runtime inference.

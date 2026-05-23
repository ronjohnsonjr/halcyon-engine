# NPC subsystem technical specifications

ADR-0008 committed the architectural pattern (LLM-as-planner with scripted execution). This ADR specifies the technical sub-decisions for that subsystem, derived from a survey of every shipped or seriously-demoed production LLM-NPC system in 2024-2026 (Where Winds Meet, Inworld, NVIDIA ACE, Convai, Mantella/Pantella, Replica, Project Sid). The architectural decision is unchanged; these are the implementation specifications it requires.

## Specifications

**Memory architecture: three-layer per NPC.**

- *Short-term*: the last N turns of conversation included in the LLM's prompt context. Initial target N=6 per Mantella's shipping default.
- *Mid-term*: an LLM-written summary per (player, NPC) pair, persisted in the world's SQLite store. Regenerated when the short-term window is about to drop relevant context. Timestamped.
- *Long-term*: a vector store (ChromaDB or equivalent embedded vector DB) per NPC, holding embeddings of significant events the NPC witnessed or was told. Retrieved via similarity search at inference time. Pantella is the open implementation reference.

NPC-to-NPC shared knowledge is NOT in MVP. Each NPC's memory is gated to its own interactions. Project Sid's PIANO architecture (parallel multi-agent shared knowledge) is research-grade and out of scope.

**Latency budgets.**

- Conversational dialogue turn (LLM + TTS, end to end): <300ms target. Production references: Inworld pipeline target <200ms, NVIDIA ACE local Minitron 4B ~300ms.
- TTS first chunk: <130ms (Inworld TTS-1.5 reference).
- Slow planning (per-game-day NPC decisions): seconds to minutes, asynchronous, completed in background.
- Polity-level simulation tick (per-game-decade RK4 integration): no real-time constraint; runs during loading screens or compressed time-skips.

**Async-with-graceful-fallback is mandatory.**

- All conversational LLM calls have a hard timeout.
- On timeout or unavailable model, NPCs fall back to canned dialogue from the affinity-flag pool or to silence with a generic gesture.
- All planning LLM calls run async; the scripted execution layer never blocks on planning. If a plan is unavailable, the NPC continues with its previous plan.
- Synchronous-blocking on the LLM is not permitted anywhere in the runtime loop.

**Allowlist tool calls.**

- The LLM cannot mutate world state directly.
- Outputs are parsed as structured JSON or function calls. Each call is validated against a per-NPC allowlist of permitted actions (e.g., `set_affinity`, `become_old_friend`, `give_gift`, `turn_hostile`, `propose_alliance`).
- Unknown tool calls fall through to no-op with a logged warning.
- Where Winds Meet's "narrative injection" exploit class (player typing "(suddenly her brothers appear)" to trick the LLM into accepting fictional state as real) is mitigated by the engine validating proposed state changes against actual game state before executing.

**Inference location and economics.**

- Server-side authoritative (per ADR-0008).
- Single-player worlds run inference in the same process; the player's machine bears the cost.
- Multiplayer worlds run inference on the dedicated server (per ADR-0001); the server operator bears the cost.
- Target model: Gemma 4 2B class. Approximately 2GB VRAM. Runs on consumer GPUs (RTX 2060+) or modest CPU. Mecha BREAK's Minitron 4B is the closest production reference.
- Active-NPC set management: only NPCs within a configurable proximity-and-relevance window run LLM inference. Estimated 5-15 active NPCs at any time on a G(4,0) MVP planet. Far NPCs run cheaper simulation or are paused.

**QA strategy.**

- *Allowlist tool calls* (above) reduce mutation surface, making property-based testing tractable.
- *Replay logs* capture the full (prompt, completion, tool call, engine state) tuple per inference call. The engine event log (per ADRs 0006, 0009) hosts these.
- *Temperature-0 regression suites* exercise NPC behavior with the same seed for deterministic CI testing.
- *Stochastic suites* at production temperature run separately with statistical assertions (rather than equality).
- *Guardrail classifiers* between LLM output and engine execution catch obvious violations.
- *Content filters* at both prompt and response boundaries. Where Winds Meet's published failure modes (sycophancy, anachronism, narrative injection) are the canonical exploit class.
- QA methodology for non-deterministic NPCs is genuinely unsolved across the industry. This is an open research opportunity and contributing-to-the-field area for the project.

## Known risks and limitations

- **No production game has shipped what we're aiming for.** Project Sid is the closest reference and is explicitly a research artifact. We are doing research-into-production work in the agentic-NPC space.
- **Storybricks failure mode**: overscope plus undercapitalization. Defense: tight MVP scope (D-architecture-B-content per ADR-0008), OSS operating model.
- **Replica failure mode**: inference cost. Defense: small-model choice (Gemma 4 2B), on-device-friendly, self-hosted operating model with operator-borne cost.
- **Behavioral testing under non-determinism is unsolved.** The QA strategy above is the current state of the art, not a complete solution.
- **Long-horizon consistency degrades.** Hours-long playthroughs strain memory fidelity. Vector-store recall is a workaround, not a solution.

## Consequences

- The world's SQLite store gains tables for: NPC short-term conversation history, NPC mid-term summaries per player, vector-store metadata.
- The engine fork gains an embedded vector database (ChromaDB or equivalent) for NPC long-term memory.
- The fork ships TTS integration (Piper as default per the open Mantella reference; alternatives swappable).
- The fork ships an async-with-fallback dispatcher for LLM calls, with explicit timeout and graceful-degradation handling.
- The Manifest schema for NPCs gains fields for the action allowlist (per-NPC permitted tool calls).
- The agent's event log captures full inference tuples for replay and regression testing.

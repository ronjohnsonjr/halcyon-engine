# NPC architecture: LLM-as-planner with scripted execution; D-architecture, B-content at MVP

NPCs use a hybrid architecture: an LLM (target: Gemma 4 2B class, server-side authoritative) generates high-level plans on a slow tick (seconds to in-game days), and traditional behavior-tree / scripted systems handle moment-to-moment execution. The architecture supports persistent NPC memory, asymmetric magic-vs-tech agency, faction alliances, and named NPCs that remember the player across sessions.

MVP content scope is mixed: two to three demonstration NPCs exercise the full planning + memory layer (option D from the grilling taxonomy). The remaining NPCs ship at the simpler option B scope (LLM-generated dialogue with affinity flags, similar to *Where Winds Meet*'s shipping architecture). Architecture is D from day one; content scope grows from B-with-D-demonstrations to full D over time.

## Considered Options

- **A. No LLMs.** Rejected: loses the flagship's distinguishing feature.
- **B. LLM-driven dialogue, scripted behavior.** *Where Winds Meet* is the production reference for this. Rejected as architecture (insufficient for persistent memory, faction alliance, agency). Accepted as content default.
- **C. LLM-driven decisions and dialogue every tick.** Rejected: latency disaster, no production references.
- **D. LLM as planner, scripted execution.** Selected as architecture.
- **E. Multi-agent LLM swarm.** Rejected: inference cost does not scale to dozens of NPCs.

## Consequences

- The engine ships an in-game LLM runtime as a first-class subsystem, separate from the authoring-time agent that builds projects.
- Inference is server-side authoritative. Single-player worlds run inference locally (same process); multiplayer worlds run inference on the dedicated server (per ADR-0001). Clients do not run inference.
- A persistent NPC memory subsystem is required: per-NPC episodic memory plus summarized long-term memory, persisted in the SQLite world store.
- Active-NPC set management is required: only NPCs near the player or otherwise narratively relevant run LLM planning. Far NPCs run cheaper simulation or are paused.
- Planning cadence is tiered: in-combat decisions on a fast tick (sub-second, via behavior trees), routine work and movement on a per-minute tick, allegiances and life goals on a per-game-day tick (LLM-driven).
- The "Mob" concept in the Manifest splits into two distinct kinds: **wildlife** (animals, monsters; pure behavior-tree, no LLM) and **NPC** (intelligent characters; LLM-planning). Schema changes accordingly.
- *Where Winds Meet*'s exposed exploit class (prompt injection, narrative injection like "(suddenly her brothers appear)") is a known failure mode. The architecture must validate LLM outputs against game state (the LLM cannot accept fictional descriptions as in-game facts; all state changes go through scripted handlers that check world state).
- LLM nondeterminism is contained: prompts, seeds, and outputs are logged to the agent event log for replay and audit.

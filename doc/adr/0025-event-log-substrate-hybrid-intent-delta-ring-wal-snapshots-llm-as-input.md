# Event Log: hybrid intent+delta events, in-memory ring with WAL and snapshots, LLM-as-input for determinism

The Event Log is the shared append-only event stream the three layers (Spatial, Temporal, Narrative) communicate through per ADR-0009. This ADR specifies what an event is, how the log is stored, how determinism is guaranteed and tested, how LLM non-determinism is handled, how multiplayer reconciliation runs against the log, and how save files reference it.

## Status

Accepted.

## Context

ADR-0009 named the Event Log as a one-liner ("shared append-only event log seeded by a single deterministic RNG") and four other ADRs implicitly depend on it: ADR-0001 (multiplayer reconciliation), ADR-0011 (NPC long-term memory persistence), ADR-0023 (Index vs Log distinction), ADR-0024 (`scene_test` determinism criteria). None of those specs work without an Event Log spec to anchor them.

The Event Log is also the substrate for save/load, the determinism testing harness, and the deterministic-replay surface the agent needs in `scene_test`. Getting it wrong forces rewrites in five other subsystems.

## Considered Options

For each decision area, the alternatives weighed:

- **D1 Event grain.** Coarse-grained intent only; fine-grained state deltas only; hybrid intent + deltas. Hybrid selected.
- **D2 Storage backing.** Pure in-memory ring; on-disk WAL only; hybrid ring + WAL + snapshots. Hybrid selected.
- **D3 Event schema source.** Code-only definitions; schema-defined only; hybrid core-in-code + extensible-via-schema. Hybrid selected.
- **D5 Tick model.** One engine tick rate with scheduled in-game-time events; multiple parallel clock systems. One engine tick rate selected.
- **D6 LLM handling.** Pinned-model determinism; cache-by-prompt-hash; treat LLM outputs as inputs to the deterministic core. LLM-as-input selected.
- **D7 Multiplayer reconciliation.** Lockstep; server-authoritative with client prediction; snapshot interpolation. Server-authoritative with prediction selected.
- **D8 Save format.** Full state dump per save; event log only with replay-from-genesis; snapshot + tail. Snapshot + tail selected.

## Decision

### D1. Event grain: hybrid intent + delta

Every event is either an **intent event** (the simulation tick, an NPC, the agent, or the player wants something to happen) or a **delta event** (the engine processed an intent and produced these state changes).

Intent events are coarse and human-readable: `NpcMoveIntent(npc_id, target_tile)`, `StoryletFireIntent(storylet_id, $sub_faction=aquilonia)`, `BlockPlaceIntent(player_id, position, block_id)`, `FactionTickDue(macro_id, parameters)`. Few thousand per game-day. Inspectable in a debugger.

Delta events are fine and machine-readable: `state_delta(entity_urn, field_pointer, old_value, new_value)`. Issued by the engine in response to processing an intent. Hundreds of thousands per game-day. The replay-as-state-load path reads only these; the replay-as-simulation path reads only intents and reproduces deltas.

Determinism check: the same intent events at the same in-game time should produce the same delta events. Divergence between two replays of the same intent stream is the bug signal.

### D2. Storage: in-memory ring + on-disk WAL + periodic snapshots

Three tiers:

- **In-memory ring buffer.** Holds the last ~game-hour of events at full volume. Engine reads this for tick-time queries (NPC asks "what happened to my faction this game-week" — reads the ring, not the disk). Sized configurably; default ~256MB.
- **On-disk WAL.** Append-only file at `<save_dir>/log/<segment_id>.wal`. Flushed at every engine tick boundary. Segments rotate every N events (default 100k) for manageable file sizes.
- **Periodic snapshots.** Every 1000 engine ticks (default; configurable), the engine writes a state snapshot at `<save_dir>/snapshots/<tick_n>.snap`. The snapshot is a delta-since-genesis — full world state minus what would be reconstructable from the Manifest Index.

MVP simplification permitted: ship in-memory ring + periodic snapshots without WAL. Cost: lose crash recovery between snapshots. Acceptable if default snapshot interval is brought down to ~one game-minute for MVP. WAL added in a follow-up release.

### D3. Event schema: core in code, mod events via Manifest

Core events (NPC moved, tick advanced, storylet fired, block placed, faction state updated, world generated, player joined, player left, save written, snapshot taken — the engine's own native vocabulary) are defined as C++/GDScript classes in the engine. Hot-path, fast serialization, no Manifest lookup.

Mod-added events are declared via JSON Schema under `schemas/events/<event_name>.schema.json`, loaded through the Manifest Loader per ADR-0023. Slower serialization path, but extensible without engine changes. Mod events are namespaced by mod id (`mod:my_dlc:custom_event_kind`).

Every event carries a `schema_version` field. Schema changes increment the version. The engine ships migration code keyed by `(event_kind, from_version, to_version)`; replay of older WAL segments runs through the migration chain before reaching the current code.

### D4. Determinism guarantees and testing harness

The determinism boundary is explicit:

**Inside the determinism guarantee** (engine must produce identical delta events for identical intent inputs):
- Simulation tick (Spatial layer block/entity updates).
- Faction state simulation (Temporal layer cohesion/strain/etc. tick).
- Storylet firing (Narrative layer salience evaluation and selection).
- NPC tool-call dispatch (the engine's processing of an LLM-decided action).
- Procedural world generation (given seed + Manifest content hash).

**Outside the determinism guarantee** (recorded as inputs to the deterministic core):
- Player input timing. Recorded as `PlayerInputIntent(player_id, action, in_game_time_microseconds)`.
- Network packet arrival order. Server-authoritative reconciliation (D7) handles this.
- LLM inference outputs. Recorded as `LlmResponseReceived(prompt_hash, response_text, in_game_time)` per D6.
- OS-level clock readings (`Time.now()`, filesystem mtimes, etc.). Engine code must not call these in the hot path; if needed, route through the seeded RNG or record as an input event.

The `engine-replay` CLI command takes a WAL + snapshot directory, runs the events through the engine, and emits a diff report. If any delta event diverges from the recorded version, the report identifies the first divergence point with both event payloads side-by-side.

The agent's `scene_test` tool from ADR-0024 wraps `engine-replay`.

CI surface: a "golden replay" test runs on every PR. A recorded session from the main branch is replayed against the PR branch; any divergence outside an acceptable list (visual effects, audio mixer state, debug overlays) fails CI.

### D5. Tick model: single engine tick rate, scheduled in-game-time events

The engine ticks at a fixed real-time rate (default 60Hz for real-time games like Project Halcyon; configurable per-project). Each engine tick:

1. Drains incoming events (player input, network packets, LLM responses returned since last tick).
2. Runs the simulation step (physics, AI, animation, storylet evaluation).
3. Emits resulting intent and delta events to the log.
4. Advances the in-game clock by `tick_duration_in_game_seconds` (real-time seconds × in-game-time-scale).

Game-time-scaled ticks from ADR-0020 (game-day cohesion update, game-week reach update, narrative ticks) are **scheduled events**, not separate clock systems. The simulation maintains an event queue keyed by in-game time; when the in-game clock crosses an event's threshold, the event fires as a regular `FactionTickDue(macro_id, parameters)` intent into the log.

The Multi-Rate Hybrid wording from ADR-0020 means scheduled events at different in-game intervals, not parallel clocks.

### D6. LLM as input to the deterministic core

LLM inference output is non-deterministic across hardware (different GPUs, drivers, tokenizer versions produce different outputs even with seed pinning). The Event Log treats LLM responses as **inputs**, not as computations to be replayed.

Live play:
1. Engine produces an `LlmRequestSent(prompt_hash, prompt_text, request_id)` event.
2. The NPC subsystem calls the LLM asynchronously.
3. When the response arrives, the engine emits `LlmResponseReceived(request_id, prompt_hash, response_text, in_game_time)`.
4. Subsequent processing of the response (tool call dispatch, dialogue rendering) is deterministic given the response.

Replay:
- The `LlmResponseReceived` events are read from the recorded log. The LLM is NOT re-queried.
- This means a recorded session is bit-exact reproducible for testing, but cannot be "continued live" without breaking the recorded determinism chain.

Implication: the determinism test harness records and replays LLM responses; the save/load system also records LLM responses for resume-correctness, but a continued live session emits fresh LLM calls and continues normally. The LLM cache is part of the save when it's being used for replay-testing; it's part of the runtime ephemeral state when it's normal gameplay.

### D7. Multiplayer: server-authoritative with client prediction

The dedicated server runs the canonical simulation and produces the canonical Event Log. Clients receive intent events for actions affecting them, and authoritative delta events for state they need to render.

Client prediction:
- Player input emitted at the client as `PlayerInputIntent`, applied locally for immediate feedback, sent to the server.
- Server processes the input, emits authoritative deltas, broadcasts to all clients.
- Client receives the authoritative delta. If it matches the predicted delta, no correction. If it diverges, the client rolls back its local state to the last server-confirmed tick and re-applies all subsequent local intents against the corrected state.

Determinism is mandatory for prediction to work well. The same intent processed by client and server must produce the same deltas given the same state — which is exactly what D4 guarantees.

Faction simulation and NPC LLM are server-only (per ADR-0008's server-side LLM authority). Clients receive these as broadcast delta events; clients never predict faction state or LLM outputs.

### D8. Save format: genesis + snapshots + tail

A save file is a directory:

```
<save_dir>/
  manifest.json          # Manifest content hash, world seed, world_gen URN, save format version
  snapshots/
    0000000000.snap      # Genesis snapshot
    0000001000.snap      # State at tick 1000
    0000002000.snap      # State at tick 2000
    ...
  log/
    0000000.wal          # Events between snapshots
    0000001.wal
    ...
```

On load:
1. Verify Manifest content hash matches the current project. Mismatch refuses load (or warns with a force-load override flag).
2. Load the most recent snapshot.
3. Replay the WAL tail from that snapshot's tick to current.

Snapshots are deltas-since-genesis, not full world dumps. The genesis state is reconstructable from (Manifest Index + world seed + procgen pass), so snapshots only encode divergence from procgen output.

The agent never edits saves. Saves are runtime artifacts. Authored content goes through the Manifest per ADR-0023. This is the clean line.

### D9. Event Log query tool for the agent

The `event_log_query` tool (new in this ADR) takes a path to a recorded log directory and a query, returns matching events.

Query forms:
- `event_kind=NpcMoveIntent` — all NPC move intents.
- `entity_urn=sub_faction:aquilonia` — all events touching this entity.
- `tick_range=1000..2000` — all events in that tick window.
- `in_game_time_range=<start>..<end>` — all events in that in-game-time window.

Combinable with AND semantics. Returns event records with full payloads.

Used by `scene_test` to assert "did the NPC actually move to the expected tile by game-hour 16?" or "did the storylet fire at the expected in-game time?" Used by humans during debugging.

Separate tool from `index_query` (ADR-0024). Different namespace, different lifecycle, different schema.

## Consequences

- **The engine is now a deterministic simulation by contract.** Every line of hot-path code is subject to "produces the same deltas given the same intents." This is a real engineering discipline; we'll catch determinism violations regularly during development. The golden-replay CI is the forcing function.
- **Saves are durable and inspectable.** A save is a directory of files an experienced user (or the agent) can read. Forensic debugging of "what went wrong in this playthrough" becomes possible.
- **Multiplayer prediction is unblocked.** With determinism guaranteed and the event log as the canonical truth, server-authoritative-with-prediction has the substrate it needs.
- **LLM costs are bounded by recording.** A recorded session's LLM costs are paid once, then replayable forever without re-incurring inference cost. Useful for QA, regression testing, and tutorial recording.
- **The save format is coupled to the Manifest content hash.** Saves don't survive Manifest changes that affect content. We mitigate with hash-tolerant loading for non-breaking changes (additive schema fields, new optional entities) and refuse-or-warn for breaking changes. Schema migration is in scope; content migration is not.
- **MVP can skip the WAL** and ship with just in-memory ring + frequent snapshots. Cost: crash recovery between snapshots is lost. Acceptable for prototype phase.
- **Mod-added events have a slower path.** Schema lookup on every emit/replay. Engineering trade we accept for extensibility.
- **Engine code is forbidden from calling Time.now() in hot paths.** This will catch developers off guard initially. CI lint rules can detect direct OS-clock reads in the simulation tick.

## Out of scope

- The exact binary format of WAL segments and snapshots. Implementation detail; protobuf, MessagePack, and bincode are all reasonable. Decide during prototyping.
- Compression. WAL segments and snapshots get bigger fast; pick a streaming-compatible compression (zstd is the default reasonable choice) during prototyping.
- The full taxonomy of core event kinds. Specified incrementally as subsystems are built; this ADR locks the structure, not the catalog.
- LLM cache hit rates and replay-vs-live mode switching UI for the agent. Future enhancement.
- Save versioning and migration tooling. Real concern; queue a follow-up ADR when the save format crosses its first breaking change.
- Crash recovery semantics for in-flight LLM requests (the request was sent, the response never came back). Engineering detail; default to "drop the request, re-queue on next tick if still needed."

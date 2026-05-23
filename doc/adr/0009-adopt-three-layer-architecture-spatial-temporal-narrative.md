# Adopt three-layer architecture: spatial, temporal, narrative

The engine adopts a three-layer architecture derived from Jacob O'Neill's *Fractal Philosophy* technical synthesis: a **spatial layer** (planet representation and tile graph), a **temporal layer** (civilization simulation, NPC planning, world tick), and a **narrative layer** (storylet manager). All three layers communicate through a shared append-only event log and a seeded RNG, providing deterministic replay and a single audit surface.

The three layers map cleanly onto the flagship game's design: Hyborian-age civilizations rise and fall via Turchin/Khaldun structural-demographic dynamics (temporal layer), the world supports voidship inter-planet travel and per-planet civilization seeding (spatial layer), and emergent narrative (player encounters, faction shifts, cosmic-horror manifestations) is produced by a salience-driven storylet manager (narrative layer) rather than by hand-authored quest trees.

## Considered Options

- **Adopt wholesale at MVP.** Selected with scoping. See ADR-0010 for spatial-layer scope. The temporal and narrative layers ship at MVP but with intentionally limited content.
- **Adopt partially with deferred spatial layer (Goldberg sphere later).** Initially recommended; rejected per ADR-0010.
- **Reject. Stay with Manifest + Scripts.** Rejected: loses the simulation framework that makes Hyborian-civilization cycles work as emergent dynamics rather than scripted lore.
- **Adopt as research direction; defer all implementation.** Rejected: leaves the engine without a simulation substrate, which then has to be retrofitted.

## Consequences

- **Spatial layer** subsystem added. Owns planetary representation (see ADR-0010), tile graph, voxel chunks at player scale, and the spatial index that maps player-coords to tile-coords.
- **Temporal layer** subsystem added. Owns the world tick (multiple cadences: per-frame for player interaction, per-game-second for physics and entities, per-game-minute for routine work, per-game-day for civilization dynamics, per-game-decade for slow Turchin-style ODE integration). RK4 integration for the slow ODEs. Per-polity state variables (population, solidarity, state strength, elite count).
- **Narrative layer** subsystem added. Owns the storylet registry (`storylets/` Entity Directories or `storylets.json` Registry File; format pending grilling), the storylet evaluator (per-narrative-tick: filter by precondition, score by salience, pick top per tier respecting cooldowns), and character memory bindings.
- **Event log unification.** The agent event log committed to in ADR-0006 expands to be the shared simulation event log. All three layers write to it; storylets read from it; replay reconstructs from it.
- **Manifest schema expands.** New Entity Directory or Registry File types needed for: Polities, Cultures, Storylets, Historical Events, Hex Tiles (per ADR-0010).
- **LLM-NPC architecture (ADR-0008) plugs into the temporal layer.** NPCs are individuals on the temporal layer; polities are aggregates. The temporal layer runs both polity dynamics (deterministic) and per-NPC LLM planning (logged for replay).
- **Visualization tooling must come early.** O'Neill's "must visualize well" principle: heat maps over the hex-sphere, phase-plot debug windows for SDT variables, storylet-trace UI. The engine ships these as editor panels.
- **Engineering effort.** Substantial. Each subsystem is real engineering. MVP scope must be tight (see ADR-0010 for spatial, future ADRs for temporal and narrative scoping).
- ENGINEERING.md is restructured to present the three layers as the top-level architecture, with Manifest, Scripts, voxel runtime, and multiplayer as components within those layers.

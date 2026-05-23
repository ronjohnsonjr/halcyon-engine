# Engine scope: survival-genre framework with flagship game

The engine is scoped as an agentic framework for **survival-genre games on Godot 4.x**. It ships with opinionated schemas for survival-genre concepts (mobs, blocks, recipes, biomes, world generation, items, crafting stations). One specific game, currently in design (steampunk, cosmic-horror, Hyborian-Age survival with analog-tech progression and eventual multi-world support), is the **flagship title** that proves the framework. Modders can build other survival games using the same schemas. Non-survival genres are out of scope.

This decision corrects the original research-report framing of "any 2D/3D game," which was too broad for a credible OSS side project and was already contradicted by the survival-specific schemas being designed.

## Considered Options

- **One specific game (engine IS the game).** Rejected: no separable engine to ship, no design effort shared across other games, the agentic-engine pitch collapses into a single-product offering.
- **Survival-genre framework with flagship game.** Selected.
- **Fully generic agentic Godot (pluggable genre packs).** Rejected for MVP: pluggable genre packs is real engineering, generic schemas defeat the agent's reasoning (the agent's intelligence emerges from reasoning over schemas with semantic meaning), and the engineering effort is incompatible with an OSS side project.

## Consequences

- Schemas already designed (mob, block, recipe, world-gen, items) are intentionally survival-genre opinionated. Generic abstractions are not a goal.
- **Flagship-first generalization.** The flagship game proves engine needs through concrete vertical slices before the engine extracts stable survival-framework abstractions. Build Project Halcyon gameplay/editor workflows first, then generalize schemas, tools, and editor surfaces from demonstrated needs. Avoid generic engine abstractions that are not demanded by the flagship game or near-term survival-modder use.
- Engineering document Section 1 is corrected: the engine is "an agentic engine for survival games on Godot 4.x," not "an agentic game engine for non-technical creators." The audience clause survives; the genre scope is tightened.
- Section 4 of the engineering document changes "Reference Title" to "Flagship Title."
- **Modding is a first-class concern.** Modders can add mobs, items, blocks, recipes, biomes, and scripts that fit the existing schemas. Modders cannot invent new top-level entity types without a schema update (and engine version bump).
- **Tension with deferred schema evolution (Q9 decision):** pre-v1.0, schemas may break between engine versions. Modders accept this. Post-v1.0, schemas become stable contracts. This is the same trajectory Vintage Story followed; it is workable but should be documented for modders.
- Other genres (platformers, RPGs, racing, etc.) may be added in a v1.0+ release via schema-pack architecture. Out of scope for MVP.
- The graduation path to a funded product remains open and is arguably sharper now: "an agentic engine for indie survival games" is a clearer market positioning than "an agentic engine for everything."

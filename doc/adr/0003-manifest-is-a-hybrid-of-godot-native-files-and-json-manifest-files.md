# Manifest is a hybrid of Godot-native files and JSON Manifest Files

The **Project Manifest** is a logical concept, not a single file. It is physically realized as two surfaces:

1. **Godot-native files** (`.tscn` scenes, `.tres` resources, `project.godot` config) for scene composition, resources, and engine-level config. Godot's own parsers and editor remain the canonical tools for these.
2. **Manifest Files** under `manifest/`: typed JSON files for project-level declarative concepts that Godot has no native slot for. Examples: `blocks.json`, `recipes.json`, `mobs.json`, `world_gen.json`. Each Manifest File has its own JSON Schema and is mutated through typed agent tool calls.

The agent operates over both surfaces, choosing the right surface for each concern.

## Considered Options

- **Manifest replaces Godot's files (single JSON document, engine generates `.tscn` / `.tres` at build).** Rejected: requires writing and maintaining a transpiler for the full `.tscn` format (custom resources, sub-resources, ext_resources, packed scenes, scene inheritance), which is a long tail of bugs for no real payoff. Reinvents tooling Godot already provides.
- **Manifest is Godot's files (no separate JSON layer).** Rejected: `.tscn` and `.tres` are awkward containers for project-level concepts like block libraries, recipes, and crafting that aren't naturally scenes or runtime resources.
- **Hybrid: Godot-native plus JSON Manifest Files.** Selected.
- **JSON shadow: agent edits JSON, engine bidirectionally syncs to `.tscn` / `.tres`.** Rejected: bidirectional sync between two representations of the same truth is a known bug source (Roblox place-file vs Studio-edit conflicts, Unity prefab variant headaches). Eventual consistency leaks.

## Consequences

- The agent's tool API has two surfaces:
  - **Scene/resource ops** use Godot's native scene-and-resource APIs (or equivalent serialization libraries) to mutate `.tscn` and `.tres` files.
  - **Manifest File ops** use JSON Schema-validated tool calls to mutate `manifest/*.json` files.
- Godot's editor remains usable for scene-level work. Technical creators who want to drop into the editor can do so without leaving the system.
- No transpiler to write, maintain, or debug.
- For game concepts that span both surfaces (a mob has a visual scene AND game-data like drops, stats, AI-script-reference), the boundary between what lives in `.tscn` and what lives in a Manifest File is itself a design decision and is deferred to a future ADR.
- Each Manifest File needs an explicit JSON Schema. Schema-evolution and migration become engineering concerns.
- The agent's event log must capture mutations across both surfaces uniformly.
- Save/load and multiplayer must serialize and replicate both surfaces consistently.

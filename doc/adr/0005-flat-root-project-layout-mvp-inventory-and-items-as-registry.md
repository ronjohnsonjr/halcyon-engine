# Flat-root project layout, MVP concept inventory, and items as a registry with scene references

The project uses a flat top-level layout. Entity Directories and Registry Files sit at the project root alongside Godot-native files. There is no `manifest/`, `entities/`, or `registries/` prefix.

The voxel survival MVP commits to the following concept inventory:

| Concept | Type | Physical location |
|---|---|---|
| Player | Entity Directory (singleton) | `player/` |
| Mobs | Entity Directories | `mobs/<name>/` |
| Crafting stations | Entity Directories | `stations/<name>/` |
| Items | Registry File with optional scene refs | `items.json` plus `scenes/items/*.tscn` for any item with a world drop |
| Voxel blocks | Registry File | `blocks.json` |
| Recipes | Registry File | `recipes.json` |
| World generation | Registry File | `world_gen.json` (biomes, spawn rules, ore distributions) |
| Audio bindings | Registry File | `audio.json` |
| Input map | Godot-native | `project.godot` |
| Cross-cutting systems (day/night, hunger, health) | Scripts plus tunables | `scripts/systems/*.gd`, tunables in `world_gen.json` or `player/data.json` |

Items is the one principled exception to the Entity-Directory-versus-Registry rule. Strictly applying the rule would put items with world drops (pickaxe, bone) into Entity Directories and items without world drops (rotten flesh, ingredient items) into a `items.json` registry. That would split items across two surfaces. We instead treat items as a pure data table with optional scene references, so all items live in `items.json` and a `world_drop_scene` field references a `.tscn` when one exists. Items are conceptually a registry; the scene is incidental.

## Considered Options

### Top-level layout

- **Flat root.** Selected. Categories at the root match how creators think about a project, and OSS contributors find what they need without learning a layout convention first.
- **Manifest-rooted (`manifest/` prefix).** Rejected. Adds depth without payoff once "Entity Directory plus Registry File equals manifest" is internalized.
- **Concern-grouped (`entities/` vs `registries/`).** Rejected. Forces the user to know the rule before they can find anything.

### Items pattern

- **(a) All items as Entity Directories, even when scene is empty.** Rejected. Empty directories for inventory-only items create ceremony without value.
- **(b) Items as a Registry File with optional `world_drop_scene` references.** Selected.
- **(c) Split items by whether they have a scene.** Rejected. Violates the convention principle.

## Resulting layout

```
project/
├── project.godot
├── player/
│   ├── data.json
│   ├── scene.tscn
│   └── controller.gd
├── mobs/
│   ├── zombie/
│   │   ├── data.json
│   │   ├── scene.tscn
│   │   └── ai.gd
│   └── skeleton/{data.json, scene.tscn, ai.gd}
├── stations/
│   ├── crafting_table/{data.json, scene.tscn, interaction.gd}
│   └── furnace/{data.json, scene.tscn, interaction.gd}
├── items.json
├── blocks.json
├── recipes.json
├── world_gen.json
├── audio.json
├── scenes/
│   └── items/
│       ├── pickaxe_dropped.tscn
│       └── log_dropped.tscn
├── scripts/
│   └── systems/
│       ├── day_night.gd
│       └── hunger.gd
├── assets/
└── .cache/
    └── manifest_index.json
```

## Consequences

- The agent's tool API maps cleanly onto two surfaces: Entity Directory ops for `player/`, `mobs/<name>/`, `stations/<name>/`; Registry File ops for `items.json`, `blocks.json`, `recipes.json`, `world_gen.json`, `audio.json`.
- Schema enforcement is per-file: each Entity Directory's `data.json` has its own JSON Schema; each Registry File has its own JSON Schema.
- Cross-references are necessary and pervasive: recipes reference items, items reference world-drop scenes, world-gen references mob and block IDs, mobs reference AI scripts. The cross-reference validation framework remains open and is the next thing to grill.
- The "system" category (day/night, hunger, health) is a third minor pattern: a script in `scripts/systems/` plus tunables in another Registry File (likely `world_gen.json`) or a per-entity `data.json` (e.g., player hunger thresholds in `player/data.json`). This is treated as a small principled exception, not a new top-level pattern.
- Godot's `project.godot` continues to own input map, autoloads, project metadata, and engine settings. The Manifest does not duplicate or shadow these.

## Open

- The day/night and hunger systems live in `scripts/systems/`, but where their tunables live (root-level config Registry vs spread across `world_gen.json` and `player/data.json`) is not fully resolved.
- Cross-reference validation framework is the next thing to grill.

# Folder-per-entity for instantiable concepts; flat registry files for pure-data tables

For any concept that is instantiable in the world (mob, item with world representation, player, crafting station, biome with a scene), state lives in an **Entity Directory** containing separated files per aspect: `data.json` for designer data, `scene.tscn` for visual, and one or more `.gd` scripts for behavior. For any concept that is a pure data table (recipes, voxel blocks, world-generation rules), state lives in a flat **Registry File**.

This decision was reached by reasoning from engineering principles rather than from genre conventions in voxel survival games.

## Considered Options

- **Tripartite scattered split (scenes own visual, central JSON manifest owns data, scripts own behavior).** Rejected: low locality, fragile cross-file refactors, three writes per change.
- **Registry pattern (one JSON manifest file per concept holds all data plus references to scenes/scripts).** Rejected: large per-concept registry files become merge-conflict hotspots in a multi-contributor project, and LLM context loads more data than necessary to answer per-entity queries. This was the original recommendation before pure-engineering reasoning was applied.
- **Godot-native custom resources (`.tres` per entity).** Rejected: GDResource format is parseable but less ergonomic for an LLM than JSON, and Godot's resource lifecycle is the wrong model for configuration data.
- **All-in-scene (`@export` properties).** Rejected: enumeration requires globbing and parsing every scene, schema validation is weak, and per-aspect audience separation is lost.
- **No rule, agent decides per case.** Rejected: predictability matters for both human contributors and agent reliability.
- **Folder-per-entity for instantiable; flat registry for pure-data tables.** Selected.

## Engineering principles applied

1. **Single source of truth.** One canonical home per datum.
2. **Strong typing across boundaries.** JSON Schema beats GDResource for static validation.
3. **Locality of change.** Per-entity directories match the agent's per-entity access pattern.
4. **LLM context efficiency.** A 1-2 KB per-entity `data.json` is cheaper to load than a 50 KB registry when answering per-entity queries.
5. **Refactor and deletion safety.** Renaming or deleting an entity is one filesystem operation on its directory.
6. **Concurrency.** Distinct entities in distinct directories means no merge conflicts between contributors working on different entities.
7. **Convention over configuration.** A single clear rule (instantiable → directory, pure-table → file).
8. **Audience separation.** Within an Entity Directory, designer (`data.json`), artist (`scene.tscn`), and programmer (`*.gd`) each have a clear file to own.

## Consequences

- The agent's tool API has two distinct surfaces for declarative state:
  - **Entity Directory ops**: `create_entity`, `read_entity_data`, `update_entity_data`, `delete_entity`. Each operates on a directory and its `data.json`.
  - **Registry File ops**: `read_registry`, `add_registry_entry`, `update_registry_entry`, `remove_registry_entry`. Each operates on a single JSON file.
- A build-time index (`.cache/manifest_index.json`) is derived from a directory walk to make cross-entity enumeration fast at runtime. The cache is a derived artifact, never a source of truth.
- The rule for "is this concept an Entity Directory or a Registry File?" is "does it have a scene or a script per instance?" Edge cases (items with optional world drops, biomes with procedural rules vs scenes) require explicit per-concept review during the schema-enumeration pass.
- Schema versioning and migration are now scoped per Entity Directory schema OR per Registry File schema, rather than across one mega-schema.
- The project's top-level directory layout becomes a meaningful design decision and is the next thing to grill.

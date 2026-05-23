# Manifest supports both authored instances and templates as separate concepts

Entity Directories in the Manifest come in two distinct kinds: **authored instances** (specific named entities like `npcs/elder_marcus/` or `polities/aquilonia/`) and **templates** (recipes for procgen entities like `npc_templates/cimmerian_villager/` or `polity_templates/warring_kingdom/`). World generation instantiates templates to produce runtime instances; authored instances are loaded directly from the Manifest.

This makes the boundary between authoring-time data (in the Manifest, version-controlled, agent-authored, reproducible from seed) and runtime data (in the world DB, per-playthrough, mutable) explicit.

## Considered Options

- **A. Manifest is all authored instances.** Rejected: forecloses procgen civilizations, which are central to the flagship game's design.
- **B. Manifest is all templates.** Rejected: removes the ability to author specific named characters and polities with hand-crafted lore.
- **C. Manifest supports both as separate concepts.** Selected.
- **D. Every Manifest entity is a template; some templates produce exactly one instance.** Rejected: unification obscures intent (the agent can't tell whether an entity is meant to be unique or generic).

## Project layout impact

```
npcs/                          authored NPC instances (ADR-0012 schema)
  elder_marcus/data.json
  king_conan/data.json

npc_templates/                 procgen NPC templates (variability fields added)
  cimmerian_villager/data.json
  hyborian_soldier/data.json

polities/                      authored polity instances
  aquilonia/data.json

polity_templates/              procgen polity templates
  warring_kingdom/data.json
  decadent_city_state/data.json
  wandering_tribe/data.json

world_gen.json                 specifies which templates to instantiate at world gen,
                               with counts, placement rules, biome preferences
```

## Consequences

- **Runtime instance addressability.** Authored instances have stable URNs (`npc:elder_marcus`). Procgen instances have generated URNs at world creation (`npc:cimmerian_villager_3f7a2b`) and persist for the lifetime of that world.
- **Manifest loading at world start.** Authored instances are read from the Manifest as canonical. Procgen instances are loaded from the world DB (where world gen wrote them at creation time, never present in the Manifest).
- **Determinism preserved.** A given world seed plus a given Manifest version produces the same procgen instances every time, including the same generated URNs.
- **Storylet template-parameter pattern.** A storylet can reference `polity:$polity` to apply to any matching polity (template-parameter; matches preconditions). A storylet can also reference `npc:elder_marcus` specifically to apply only to that authored character.
- **Validator extension.** The validator knows the difference between an authored-instance URN (must resolve in Manifest) and a template URN (must resolve in `npc_templates/` or `polity_templates/`). Runtime URNs (`npc:cimmerian_villager_3f7a2b`) are not validated at authoring time.
- **Template schemas include variability fields.** A `cimmerian_villager` template specifies name-generation patterns, personality-variation ranges, drive distributions, and similar randomization knobs. Schemas for templates and authored instances are related but distinct.
- **Agent authoring workflow.** When the agent creates a new NPC, it picks: is this a specific named character (write to `npcs/`) or a kind that should be procgen'd (write to `npc_templates/`)? The choice is part of the design decision the agent surfaces to the user.

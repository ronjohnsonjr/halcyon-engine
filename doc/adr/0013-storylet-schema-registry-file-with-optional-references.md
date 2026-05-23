# Storylet schema: Registry File with optional script and content references

Storylets are stored as entries in `storylets.json` (Registry File pattern). Each entry holds the storylet's tier (Major / Minor / Flavor), preconditions (queries against world state and the event log), salience (inline expression or external script reference), effects (inline declarative list or external script reference), content (inline string or external content-file reference), and cooldown.

Simple storylets are pure data inline. Complex storylets escape into scripts and content files via references. This mirrors the items pattern from ADR-0005, where most items are pure data but some carry `world_drop_scene` references when scenes are needed.

## Considered Options

- **A. Registry File with optional references for complex storylets.** Selected.
- **B. Entity Directory always.** Rejected: hundreds of Flavor storylets at MVP would create folder explosion (500+ folders, 1500+ files), losing the single-document audit benefit.
- **C. Hybrid by tier.** Rejected: adds a "where does this storylet live?" dimension to the agent's authoring decisions without clear benefit.
- **D. Separate Registry Files by tier.** Rejected: similar to C without the folder cost; still adds the "which file?" decision.

## Schema sketch (illustrative)

```json
storylets.json:
{
  "village_stranger": {
    "tier": "Flavor",
    "preconditions": [
      {"query": "polity_at_peace", "polity_self": true},
      {"query": "time_since_event", "event_type": "stranger_arrival", "min_seconds": 86400}
    ],
    "salience": "0.3",
    "effects": [
      {"type": "spawn_temporary_npc", "from_template": "wandering_stranger"}
    ],
    "content": "A stranger passes through, eyes hollow with road dust.",
    "cooldown": 100,
    "cooldown_unit": "in_game_hours"
  },
  "succession_crisis": {
    "tier": "Major",
    "preconditions": [
      {"query": "polity_ruler_status", "polity": "$polity", "status": "dead"},
      {"query": "polity_heir_exists", "polity": "$polity", "value": false}
    ],
    "salience": {"script": "scripts/storylets/succession_crisis_salience.gd"},
    "effects": {"script": "scripts/storylets/succession_crisis_effects.gd"},
    "content": {"file": "content/storylets/succession_crisis.md"},
    "cooldown": 365,
    "cooldown_unit": "in_game_days"
  }
}
```

## Consequences

- **Storylet schema is one of the JSON Schemas drafted next.** Fields: tier (enum), preconditions (array of typed query objects), salience (string expression or `{"script": "..."}` reference), effects (array of typed effect objects or `{"script": "..."}` reference), content (string or `{"file": "..."}` reference), cooldown (integer), cooldown_unit (enum).
- **Precondition queries form their own typed mini-language.** A short list of query types (e.g., `polity_at_peace`, `polity_ruler_status`, `time_since_event`, `npc_has_drive`, `tile_has_biome`, `world_event_recent`) covers most storylet needs. Extensible.
- **Effect types form a typed mini-language.** Similar pattern (e.g., `spawn_temporary_npc`, `set_affinity`, `set_polity_solidarity`, `emit_event`, `unlock_recipe`).
- **The validator checks** that every referenced script and content file exists, every Reference URN resolves, every query and effect type is defined.
- **Polity-scoped storylets** use `$polity` as a template parameter so a single storylet entry can apply to any polity matching its preconditions (rather than authoring per-polity copies).

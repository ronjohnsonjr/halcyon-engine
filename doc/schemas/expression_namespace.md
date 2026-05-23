# World-State Expression Namespace

This document describes the runtime namespace available to salience expressions in storylets (per ADR-0013 and storylet.schema.json) and to other inline expression contexts. The validator accepts expression strings syntactically; the engine's expression evaluator validates references against this namespace at runtime and emits errors for undefined paths.

## Expression syntax

Inline expressions support:

- Numeric literals: `0.3`, `1`, `0.5e-2`
- Arithmetic operators: `+`, `-`, `*`, `/`, `%`
- Parentheses for grouping
- Dotted-path reads against the namespace below: `sub_faction.cohesion`, `tile.cosmic_horror_susceptibility`
- Comparison operators in conditional contexts: `<`, `<=`, `==`, `>=`, `>`, `!=`
- Function calls (limited): `min(a, b)`, `max(a, b)`, `clamp(x, lo, hi)`, `abs(x)`

Expressions evaluate to a number. For storylet salience, the output is a non-negative score; the storylet manager normalizes and ranks within a tier.

## Available namespaces

### sub_faction

Available when a storylet's preconditions match against a Sub-Faction. The Sub-Faction in scope is determined by template parameter binding (`$sub_faction` in the storylet definition). The six State Vector parameters per ADR-0020:

- `sub_faction.cohesion` - internal solidarity, [0, 1]
- `sub_faction.reach` - geographic and political projection, [0, 1]
- `sub_faction.mandate` - legitimacy of leadership, [0, 1]
- `sub_faction.martial_power` - military capability, [0, 1]
- `sub_faction.defensive_posture` - fortification and readiness, [0, 1]
- `sub_faction.strain` - internal pressure, [0, 1]

Auxiliary state:

- `sub_faction.treasury` - accumulated state surplus (float, >= 0)
- `sub_faction.tile_count` - number of hex tiles owned (int)
- `sub_faction.is_at_war` - boolean (true if Sub-Faction has any active war)
- `sub_faction.years_since_last_succession` - int
- `sub_faction.macro_faction_urn` - URN of parent Macro (opaque in expressions)
- `sub_faction.ruler` - URN of current ruler NPC (dot-path access enabled, e.g., `$sub_faction.ruler`)

### macro_faction

Available when a storylet matches at the macro level (`$macro` parameter). Rolled-up state from member Sub-Factions per the Macro's `rollup_strategy`.

- `macro_faction.aggregate_cohesion` - rolled-up cohesion, [0, 1]
- `macro_faction.aggregate_reach` - rolled-up reach, [0, 1]
- `macro_faction.aggregate_mandate` - rolled-up mandate, [0, 1]
- `macro_faction.aggregate_martial_power` - rolled-up military, [0, 1]
- `macro_faction.aggregate_strain` - rolled-up strain, [0, 1]
- `macro_faction.sub_faction_count` - count of living Sub-Factions
- `macro_faction.player_reputation` - current player rep with this macro, [-1, 1]

### tile

Available when a storylet matches a specific tile (`$tile` parameter).

- `tile.biome_id` - reference URN (string, treated as opaque in expressions)
- `tile.cosmic_horror_susceptibility` - from biome definition (float, [0, 1])
- `tile.cosmic_horror_active_intensity` - current manifestation intensity at this tile (float, [0, 1])
- `tile.sub_faction_owner_urn` - URN of owning Sub-Faction (string)
- `tile.is_unclaimed` - boolean

### world

Always available.

- `world.season` - "spring" | "summer" | "autumn" | "winter" (string, only valid in comparison context)
- `world.time_in_days` - in-game days since world start (int)
- `world.current_year` - in-game year (int)
- `world.cosmic_horror_intensity_avg` - global average across all tiles (float, [0, 1])
- `world.blood_moon_active` - boolean

### npc

Available when a storylet matches a specific NPC (`$npc` parameter, or via `$sub_faction.ruler` dot-path).

- `npc.affinity_with_player` - float, [-1, 1]
- `npc.is_alive` - boolean
- `npc.has_drive.<drive_id>` - returns drive weight if held, 0 otherwise (e.g., `npc.has_drive.protect_village`)

### player

Always available; the player Arcadian's current state per the Project Halcyon Drift system.

- `player.resonance_drift` - current Resonance Drift, [0, 100]
- `player.null_drift` - current Null Drift, [0, 100]
- `player.resonance_band` - "quiet" | "listening" | "heard" | "transmitting" | "receiver"
- `player.null_band` - "steady" | "slipping" | "thinning" | "coming_apart" | "sundered"

## Examples

Simple constant:

```
"salience": "0.3"
```

State-vector-driven salience (succession crisis intensity scales with mandate weakness and strain):

```
"salience": "sub_faction.strain * 0.6 + (1 - sub_faction.mandate) * 0.4"
```

Conditional via clamp (only fires when strain is above 0.5):

```
"salience": "clamp(sub_faction.strain - 0.5, 0, 1) * 2.0"
```

Cross-namespace (cohesion plus global cosmic horror):

```
"salience": "sub_faction.cohesion * 0.4 + world.cosmic_horror_intensity_avg * 0.3"
```

Player-state-driven (storylet fires more strongly for high-Drift players near a Pentagon Site):

```
"salience": "(player.resonance_drift / 100) * 0.5 + tile.cosmic_horror_active_intensity * 0.5"
```

## Failure modes

- **Undefined path**: engine logs an error, treats the expression as 0, and the storylet is dropped from the eligibility pool for that narrative tick.
- **Type mismatch** (e.g., comparing a string field to a number): engine logs an error, drops the storylet.
- **Division by zero**: engine substitutes a small epsilon to avoid crashes and logs a warning.

## Extension

New variables added by future subsystems (climate, hydrology, magic-tradition state, voidship presence, Drift-Gated Ability state) extend this namespace with new top-level prefixes. Existing expressions remain valid. Schema-side, expressions remain plain strings; runtime-side, the namespace dictionary grows.

# Sub-Faction State Vector: 6-parameter model supersedes 4-variable Turchin

Sub-Factions carry a 6-parameter State Vector per the Project Halcyon design doc, adapted from the Dynamic Factions mod with Turchin/Khaldun structural-demographic framing. This supersedes ADR-0015's 4-variable Turchin model (N, S, W, E).

## Status

Accepted. **Supersedes ADR-0015.**

## Context

ADR-0015 locked the 4-variable Turchin model (Population N, State Strength S, Wellbeing/Instability W, Elite Count E) plus auxiliary state (solidarity, treasury). It was research-derived from Peter Turchin's structural-demographic theory.

The Project Halcyon design doc (handed off after ADR-0015 was locked) specifies a 6-parameter State Vector with different semantics, finer game-relevance, and a Multi-Rate Hybrid tick schedule:

- **Cohesion** (game-day tick): internal solidarity, asabiyyah/elite-population bond.
- **Reach** (game-week tick): geographic and political projection; sets Influence Zone radius.
- **Mandate** (event-driven only): legitimacy of leadership; rises/falls on legitimating events.
- **Martial Power** (game-week tick): military capability for war and raid outcomes.
- **Defensive Posture** (event-driven only): fortification and readiness; modifies attacker cost.
- **Strain** (game-day tick): internal pressure; crossing thresholds fires Strain Events.

The 6-parameter model is more granular for game logic (storylet preconditions, Storyteller event firing, faction visibility levels), more aligned with the gameplay surface the player will see (Faction Codex UI displays these directly), and matches the design doc's authoritative terminology.

## Considered Options

- **Option A: Replace the 4-variable model with the 6-parameter State Vector.** Selected.
- **Option B: Keep 4-variable Turchin as underlying simulation, derive the 6 parameters from it.** Rejected. Adds an indirection layer the engine doesn't need; the design has already committed to the 6-parameter model as the canonical surface. Translation between the two adds bugs and reduces clarity.
- **Option C: Keep both, document the 6 as a presentation layer.** Rejected for the same reason as B.

## Decision

The Sub-Faction `initial_state` block holds six required parameters plus an optional `treasury`:

```
cohesion           [0, 1]   game-day tick
reach              [0, 1]   game-week tick
mandate            [0, 1]   event-driven only
martial_power      [0, 1]   game-week tick
defensive_posture  [0, 1]   event-driven only
strain             [0, 1]   game-day tick
treasury           >= 0     auxiliary
```

The Sub-Faction Template's `initial_state_ranges` mirrors the same six parameters as NumberRange sampled at instantiation.

The Storylet's `SubFactionStateThresholdQuery` and the two effect schemas (`SetSubFactionStateVariableEffect`, `ModifySubFactionStateVariableEffect`) update their variable enums to the new parameter names.

The expression namespace (`expression_namespace.md`) updates `sub_faction.*` paths to the new parameter names.

## Backfill applied

- **5 Sub-Faction samples** rewritten with new State Vector values (heuristic translation from old N/S/W/E):
  - `aquilonia`: cohesion 0.68, reach 0.78, mandate 0.72, martial_power 0.80, defensive_posture 0.65, strain 0.18.
  - `cimmeria_clans`: cohesion 0.88, reach 0.35, mandate 0.42, martial_power 0.55, defensive_posture 0.70, strain 0.08.
  - `thessaly`: cohesion 0.42, reach 0.85, mandate 0.55, martial_power 0.60, defensive_posture 0.45, strain 0.48.
  - `crash_site_camp`: cohesion 0.85, reach 0.10, mandate 0.50, martial_power 0.40, defensive_posture 0.30, strain 0.15.
  - `forgotten_halls`: cohesion 0.18, reach 0.05, mandate 0.05, martial_power 0.25, defensive_posture 0.10, strain 0.92.
- **5 Sub-Faction Template samples** rewritten with new ranges.
- **1 storylet sample** updated to use new variable names in salience expression and effect targets.

## Consequences

- **ADR-0015 is superseded.** The Turchin coefficients on Culture (asabiyyah_gain_rate, asabiyyah_decay_rate, elite_reproduction_rate, state_overhead_beta, tax_efficiency_rho, carrying_capacity_coupling) remain on the culture schema for now and inform the **simulation tick functions** that update the 6-parameter State Vector. They are the *under-the-hood* simulation; the 6 parameters are the *over-the-hood* state. A future ADR may rename these coefficients to align with the new parameter names, but doing so now risks losing the structural-demographic clarity for runtime engineering. Deferred.
- **Multi-Rate Hybrid tick schedule is implied but not enforced by schemas.** The schemas record the values; the engine's simulation tick decides which parameter updates when per the design doc. Per ADR-0020, Cohesion and Strain tick game-day; Reach and Martial Power tick game-week; Mandate and Defensive Posture are event-driven. Halcyon Internal Sub-Factions tick faster (Cohesion game-hour, Strain game-day) due to player proximity.
- **The 4-variable Turchin model survives in the research record.** ADR-0015 remains in the decision log as superseded but historically meaningful; the structural-demographic theory it referenced is the basis for the new model.
- **Strain becomes a load-bearing concept.** Strain Events (per the design doc) fire when Strain crosses thresholds. The Storyteller listens for these crossings and instantiates Strain Event storylets with Resolution Windows.
- **49/49 samples validate** after the rewrite.

## Out of scope

- Renaming Turchin coefficients on Culture to match the new parameter names. Deferred.
- Specifying the exact simulation tick equations (how cohesion updates as a function of culture coefficients, demographic state, and recent events). Deferred to ENGINEERING.md or a dedicated simulation ADR.
- Adding macro_faction-level state to the schemas. Macros currently expose only `player_reputation_initial` plus an attitudes array; rolled-up aggregate state is computed at runtime from member Sub-Factions per the macro's `rollup_strategy`. Adding macro-level state to the schemas is out of scope.

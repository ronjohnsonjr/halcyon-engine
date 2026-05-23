# Terminology alignment with Project Halcyon design: polity becomes sub_faction; macro_faction added

The engineering session originally used "polity" as the unit of political authority and territorial control. The Project Halcyon design document (provided as context after the engineering session matured) instead uses a two-level structure: **Macro Faction** as the highest-level cultural-political identity, composed of **Sub-Factions** as the named political units where state and political events actually live. This ADR captures the terminology and schema alignment between the two.

## Status

Accepted.

## Context

ADR-0014 introduced "polity" as the unit of political authority for authored instances and templates. ADR-0015 specified the 4-variable Turchin model running on each polity. The design document handed off later specifies a richer political model:

- Approximately **4 Macro Factions** in the flagship game (Karnish, Veranthi, Sethrai, Halcyon).
- Approximately **20-30 Sub-Factions** total at world start, distributed across the macros (House Var Tarrick, Pinewolf Hold, Black Iris Trade-House, Helios-Revivalists, etc.).
- State Vectors live at the **Sub-Faction level**; macro-level state rolls up.
- Player reputation is tracked at **both levels**.

The "polity" concept maps cleanly to Sub-Faction. The Macro layer is new.

## Considered Options

- **Option A: Rename `polity` → `sub_faction`, add `macro_faction` schema.** Selected. Matches the design doc verbatim. Requires a wide rename pass (schema files, sample dirs, URN regex, content references) but the rename is mechanical.
- **Option B: Keep `polity` as the schema name, add `macro_faction` as a peer.** Rejected. Conflicts with the design doc's authoritative terminology; would force translation between docs and schemas indefinitely.
- **Option C: Treat the four Macros as specially-tagged Sub-Factions, skip the Macro schema.** Rejected. Loses semantic clarity. Macros and Sub-Factions have different state-vector roll-up rules, different player-reputation semantics, and different Tick Rates in the design doc; collapsing them obscures these differences.

## Decision

The schemas use the Project Halcyon design doc's terminology:

- **`macro_faction.schema.json`** (new): the top-level cultural-political identity. Karnish, Veranthi, Sethrai, Halcyon. Each carries a primary culture, biome affinity, default attitudes toward other macros, player reputation initial, and a rollup strategy for aggregating sub-faction state.
- **`sub_faction.schema.json`** (renamed from `polity.schema.json`): named political units within a Macro. Each carries a required `macro_faction` URN parent reference, plus the existing fields (culture, initial state, ruler, tile assignment, etc.).
- **`sub_faction_template.schema.json`** (renamed from `polity_template.schema.json`): templates for procgen-instantiated Sub-Factions.

URN regex (per ADR-0006) gains `macro_faction` and `sub_faction|sub_faction_template` as allowed kinds. `polity` and `polity_template` removed; no backward compatibility (we are pre-release).

All cross-cutting renames also applied:
- Field names: `polity_name_patterns` → `sub_faction_name_patterns`, `polity_generation` → `sub_faction_generation`, etc.
- Template parameters: `$polity` → `$sub_faction`.
- Storylet query/effect type names: `polity_at_peace` → `sub_faction_at_peace`, `ModifyPolityStateVariableEffect` → `ModifySubFactionStateVariableEffect`, etc.

Culture rename, applied opportunistically as part of the same pass:
- `culture:cimmerian` → `culture:karnish`
- `culture:aquilonian` → `culture:veranthi`
- `culture:stygian` → `culture:sethrai`
- `culture:spacefaring_arcadia` → `culture:arcadian`
- Biome IDs rebased: `cimmerian_pine_forest` → `karnish_pine_forest`, etc.
- NPC template IDs rebased: `cimmerian_villager` → `karnish_villager`, etc.

## Consequences

- **Sub-Factions belong to exactly one Macro.** Required field, no exceptions. Modeled on the design doc's clean macro→sub hierarchy.
- **Four Macro Faction samples authored** (karnish, veranthi, sethrai, halcyon) plus the existing five Sub-Faction samples backfilled with their Macro parent.
- **`is_player_macro: true`** marks the Halcyon Macro for the player faction. Special handling for visibility, storyteller framing, and recruitment defaults will reference this flag.
- **Rollup strategy is per-Macro.** weighted_average is the default; dominant_member is used for monarchic Macros where one sub-faction effectively speaks for all (Veranthi crown dynamic).
- **ADR-0014 (templates) and ADR-0018 (Pentagon seeding) still apply.** Pentagon seeding pools sample from cultures with appropriate eligibility, and Sub-Factions instantiated at Pentagon Sites still attach to their parent Macro normally.
- **ADR-0015 (4-variable Turchin) is NOT superseded by this ADR.** That supersession is queued for the next pass, where the 6-parameter State Vector model from the design doc replaces the 4-variable Turchin.
- **No backward compatibility shims.** Old polity URNs do not resolve; old `polity_` fields do not exist. Anything outside the schemas/samples (notes, sketches, draft content from earlier sessions) needs manual updating.
- **49/49 samples validate** against 22 schemas as of this ADR.

## Out of scope

- Adding State Vector parameters (Cohesion, Reach, Mandate, Martial Power, Defensive Posture, Strain) to the Sub-Faction schema. Queued for ADR-0020.
- Creating new entity schemas for Resonance Web artifacts, Tesla Cores, Bosses, Settlement Points. Queued for ADRs 0021+.
- Adding recruitment fields (Resolve, Will, Loyalty, Coerced, etc.) to the NPC schema. Queued.
- Renaming `sub_faction:aquilonia` and other content-flavored Sub-Faction IDs to design-doc-aligned names (`sub_faction:tarricks_crown` or similar). Content-level; deferred to a future content pass.

# Four new entity schemas for Project Halcyon content: artifacts, Tesla Cores, bosses, settlements

Four new entity schemas were added to support content types specified in the Project Halcyon design doc that don't fit existing schemas: Resonance Web artifacts, Tesla Cores, Bosses, and Settlement Points.

## Status

Accepted.

## Context

The Project Halcyon design doc specifies content types the engineering session's earlier schema work didn't cover:

- **Resonance Web Artifacts** with a four-class hierarchy (Heart/Voice/Eye/Hand), Broadcast/Silence/Balanced alignment, procgen placement between Halcyon Cargo Manifest and planet-native sites, and load-bearing endgame roles for the seven Heart-Class artifacts.
- **Tesla Cores** in three grades (Standard/Refined/Architect), with a finite world-budget cap per playthrough and a five-tier Acquisition Pathway. The Standard grade is manufacturable behind the optional Manufacturing Mode toggle; Refined and Architect are not.
- **Bosses** in five tiers (early Void-Touched through cosmic Endgame), each admitting multiple Resolution Paths (combat, negotiation, cosmological puzzle, bargain, ritual). Not every boss is killable. Tier 3+ bosses grant chooseable Boss-Defeat Enhancements.
- **Settlement Points** as named, lore-bearing geographic locations belonging to a parent Sub-Faction. Each Sub-Faction holds 1-3 settlements. Settlements contribute to their parent Sub-Faction's State Vector; loss directly modifies Martial Power, Defensive Posture, and Reach.

These could be jammed into existing schemas (items, wildlife, polities-now-sub_factions) but each carries enough specialized fields and lifecycle behavior that a dedicated schema is cleaner.

## Considered Options

- **Option A: Four new dedicated schemas.** Selected. One schema per entity type, with the existing `item.schema.json` and `wildlife.schema.json` left alone.
- **Option B: Extend existing schemas with discriminator-based variants.** Rejected. Bosses sharing a schema with wildlife forces wildlife to carry resolution_paths it doesn't need. Artifacts sharing with items conflates the simple item model (which is a Registry File) with the much richer per-instance entity authoring needed for artifacts (which is Entity Directory). The discriminator approach also makes the validator messages less helpful at authoring time.
- **Option C: A generic "narrative entity" schema covering all four.** Rejected. Settlement geography rules and boss resolution paths and artifact endgame roles have no overlap; collapsing them obscures intent.

## Decision

Four new schemas, all conforming to existing patterns (Entity Directory for items with per-instance authoring fidelity; Registry File for items that are essentially a collection of similar small entries):

- **`artifact.schema.json`** (Entity Directory: `samples/artifacts/<id>/data.json`). Required: `id, display_name, artifact_class, alignment, placement_pool`. The seven Heart-Class artifacts have canonical authored IDs (chorus_drive, silence_kernel, axion_halo, architects_key, null_engine, wound_of_echoes, prime_array). Voice/Eye/Hand artifacts can be authored or procgen-named. The `endgame_role` enum captures which artifacts are load-bearing for which of the five endings.

- **`tesla_core.schema.json`** (Registry File: `samples/tesla_cores.json`). Three entries representing the three grades. Each has `grade`, `salvageable_from` enum array (per the five-tier Acquisition Pathway), `world_budget_range` for procgen, `manufacturable` flag plus optional `manufacture_recipe`, and `drift_on_use` accumulation. Registry File rather than Entity Directory because there are only ever ~3-5 grades total; per-instance authoring fidelity would be overkill.

- **`boss.schema.json`** (Entity Directory: `samples/bosses/<id>/data.json`). Required: `id, display_name, tier, archetype_role, resolution_paths`. `combat_profile` is optional (non-killable bosses like the Veiled Sleeper have no combat resolution path; their `resolution_paths` array contains only negotiation/puzzle/bargain entries). `defeat_enhancement_options` array carries the chooseable Tier 3+ rewards. `biome_clear_effect` captures the regional cleansing that Tier 3+ defeats produce.

- **`settlement.schema.json`** (Entity Directory: `samples/settlements/<id>/data.json`). Required: `id, display_name, sub_faction, settlement_type, tile_assignment, population_capacity`. Each settlement holds a `settlement_state_contributions` block describing what it adds to its parent Sub-Faction's State Vector. The `ruined_state` optional block carries the "this is a Ruin from a dead Sub-Faction" content: former Sub-Faction URN, former leader name, void-touched haunting chance.

## URN regex update

`artifact|tesla_core|boss|settlement` added to the ReferenceURN allowed-kinds list. The URN format is unchanged.

## Sample instances authored

- **Artifacts (3)**: `chorus_drive`, `silence_kernel`, `prime_array`. The three demonstrate the three placement pools (either, planet_native_only, tier_locked) and three endgame roles (none, annihilation_left, merge_pivot).
- **Tesla Cores (3)**: `standard_core`, `refined_core`, `architect_core`. One entry per grade. Validates the budget-range and manufacturability variation across grades.
- **Bosses (3)**: `whispering_hermit_boss` (Tier 1, combat + negotiation), `sundered_hold` (Tier 3, combat + ritual + bargain, with biome clear and 3 chooseable enhancements), `veiled_sleeper` (Tier 4, non-killable, negotiation + puzzle + bargain only).
- **Settlements (3)**: `pinewolf_hold` (Karnish hold for cimmeria_clans Sub-Faction), `tarricks_crown` (Veranthi capital for aquilonia Sub-Faction), `black_iris_quay` (Sethrai trade post for thessaly Sub-Faction).

## Consequences

- **59/59 samples validate** against 26 schemas after this ADR.
- **The Heart-Class seven and the seven Drift-Gated Abilities are now content commitments.** All seven Hearts named in the design doc need authored entries before flagship-game content authoring is complete; only three are authored so far. The remaining four (axion_halo, architects_key, null_engine, wound_of_echoes) need stubs.
- **Boss authoring is wide-open.** 12-15 archetypes are needed total per the design doc; three are authored so far. Tier 2 bosses (faction-political Sundered Champions) and Tier 5 bosses (cosmic Endgame) are entirely unrepresented yet.
- **Settlement authoring scales with Sub-Faction count.** Each of the 20-30 Sub-Factions wants 1-3 named settlements. Three authored so far.
- **The macro_faction URN field on settlement is not modeled.** Settlements belong to Sub-Factions, not directly to Macros; the Sub-Faction's parent macro is resolved transitively. This is the right structural choice but means a settlement's macro affiliation requires one indirection at runtime.

## Out of scope

- Authoring the remaining 4 Heart-Class artifacts. Content work, not schema work.
- Tier 2 and Tier 5 boss archetype authoring. Content work.
- Authoring the full Sub-Faction roster (20-30 named Sub-Factions across the four Macros). Content work.
- Adding recruitment fields to the NPC schema (Resolve, Will, Loyalty, recruitment_pathway). Queued for the next pass.
- Adding Drift accumulation fields to items and a Cargo Manifest block to world_gen. Queued.
- Drift-Gated Ability schema, Boss-Defeat Enhancement schema as a registered ability type rather than a free-form options array. Deferred.

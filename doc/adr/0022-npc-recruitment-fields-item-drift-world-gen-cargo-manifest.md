# NPC recruitment fields, item Drift/gear category, world_gen Cargo Manifest

Schema extensions for the Drift system, the recruitment Pathways, and the Cargo Manifest, completing the alignment pass with the Project Halcyon design doc.

## Status

Accepted.

## Context

Three areas of the design doc had no schema support before this ADR:

- **NPC recruitment.** Five Pathways (Quest, Relationship, Opportunity, Faction-Standing, Coercion) plus the Resolve/Will/Loyalty/Suppression model adapted from RimWorld. NPCs need to carry recruitment-state fields so the engine can drive the pathway lifecycle and the Storyteller can fire pathway-appropriate events.
- **Drift on item use.** The Drift system distinguishes Conventional Gear (no Drift accumulation) from Drift-Powered Gear (per-use Drift, scaled by the Accumulation Curve). Items previously had no field expressing this; everything was implicit through tags.
- **Cargo Manifest world generation.** Per-playthrough procgen splits the seven Heart-Class artifacts and ~12-25 lower-class artifacts between the Halcyon's recoverable cargo and planet-native placements. The previous `world_gen` schema had no block for this.

## Decision

Three schema extensions, no new schemas.

### NPC schema: recruitment_state block (optional)

Added to `npc.schema.json` as an optional top-level block. Absent means the NPC is not in the recruitment system at all (Authored Companions who are already members of the player's faction). Present means recruitment-relevant state lives here:

- `is_recruitable` (bool, default true): false for Void-Touched, the Veiled Sleeper, and other unrecruitable NPCs.
- `resolve` (0-100): voluntary-recruitment threshold; the high-quality slow path.
- `will` (0-100): forced-recruitment threshold; the fast-but-costly path.
- `loyalty` (0-100): per-NPC rapport with the Halcyon. Per-NPC, not per-player.
- `recruitment_pathway` enum: which of the five Pathways (plus `founding_member` for the 78 crash survivors who didn't need recruiting).
- `is_coerced` (bool): true if NPC joined via Coercion.
- `suppression` (0-100): active only when coerced; rebellion math input.
- `unwaveringly_loyal` (bool): blocks Resolve reduction; Will reduction or slow Conversion are the only paths.
- `conversion_progress` (0-100): the slow redemption arc for coerced NPCs.

### Item schema: gear_category and drift_on_use

Added to the item entry in `item.schema.json`:

- `gear_category` enum: `conventional` | `drift_powered`. Omitted for raw materials and abstract resources.
- `drift_on_use` object: `resonance_per_use` and `null_per_use` baseline values. Engine scales by the Drift Accumulation Curve at runtime.

### world_gen schema: cargo_manifest block

Added to `world_gen.schema.json` as an optional top-level block:

- `total_artifact_count_range`: design doc range 12-25.
- `heart_class_split`: structured cargo-vs-planet-native count ranges for the seven Heart-Class artifacts plus a list of `tier_locked_artifacts` (notably Prime Array) that bypass the split.
- `voice_class_count_range`, `eye_class_count_range`, `hand_class_count_range`: per-class budget ranges.
- `wreckage_recovery_curve`: pacing of how cargo artifacts surface to the player over the Opening Sequence and mid-game.

## Sample backfill

- **5 NPC samples** got recruitment_state blocks:
  - `aelius_voss`: Halcyon Captain. `is_recruitable: false`, `recruitment_pathway: founding_member`, loyalty 92.
  - `elder_marcus`: Karnish elder. `is_recruitable: true`, resolve 65, will 35, pathway `faction_standing`, `unwaveringly_loyal: true`.
  - `merchant_princess_yara`: Sethrai defector candidate. resolve 38, will 22, pathway `opportunity`.
  - `queen_selene`: Veranthi monarch. resolve 95, will 60, pathway `quest`, `unwaveringly_loyal: true`.
  - `whispering_hermit`: Void-Touched. `is_recruitable: false`.
- **3 item entries** tagged: `iron_sword` is `conventional`; `magical_inscribed_amulet` and `void_glass_shard` are `drift_powered` with appropriate per-use values.
- **`world_gen.json`** got a `cargo_manifest` block: 12-25 total artifacts, 3-4 Hearts in cargo, 3-4 planet-native, Prime Array tier-locked. Voice/Eye/Hand class budget ranges. Wreckage recovery curve with act_3_known_fraction 0.1 and mid_game_known_fraction 0.6.

## Consequences

- **59/59 samples validate** against 26 schemas after this ADR.
- **Recruitment is now schema-supported but not engine-implemented.** The fields exist; the rebellion math, Conversion arc, Suppression decay, and Pathway-specific event firing live in the runtime, not the schemas.
- **Drift baseline per use is a number, not a curve.** The Accumulation Curve (1x/2x/4x/8x by 30-point band) lives in the engine, not the schema. Items declare baseline; runtime scales.
- **Cargo Manifest cargo-vs-planet split is procgen.** Specific Heart-Class artifacts go into one pool or the other per playthrough. Authored hints (the `placement_pool` field on each artifact) constrain procgen choice; the `tier_locked_artifacts` list bypasses the split entirely.
- **Recruitment fields are optional but expected on most authored NPCs.** Wildlife and obviously-unrecruitable hostiles can omit. Most Companion/Colonist NPCs should carry them so the Storyteller has data to drive event firing.

## Out of scope

- Drift-Gated Ability schema. Six abilities are named in the design doc (Tune, Channel, Project, Quiet, Slip, Erase); a future schema can register them but the runtime can hardcode them for now.
- Strain Event schema (a structured sub-type of storylet). Probably overlay-able onto the existing storylet schema; deferred until storylet authoring volume justifies the specialization.
- Survival Difficulty Mode preset schema (Heavy/Medium/Light + granular sub-toggles). Probably belongs to a player_preferences schema or a game-start config schema. Deferred.
- Knowledge Unlock schema. The progression system per the design doc; a future schema can register named unlocks with prerequisites. Deferred until content authoring needs it.

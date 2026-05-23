# Pentagon Site seeding: constraint-based procgen from an eligibility-tagged culture pool

The 12 Pentagon Sites (per ADR-0017) are filled at world generation by sampling from the available culture pool, constrained by per-culture eligibility declarations. The Pentagon Sites are fixed geometric features; the cultures that seed them are not. Adding cultures (by the project, by modders, by content updates) extends the eligibility pool without re-authoring Pentagon assignments.

The 4 Face-Center Pentagons sample from cultures tagged `founding` or `ruined`. The 8 Corner Pentagons sample from cultures tagged `corrupt`, or fall back to a procedurally generated cosmic-horror site if no corrupt culture is present in the pool. A culture's eligibility tag is a declaration in its `culture.schema.json` entry; world generation reads the pool, filters by eligibility, and seeds Pentagon polities accordingly. Per-run variation is built in: different worlds pick different founding-culture distributions from the eligible pool.

## Status

Accepted.

## Context

ADR-0017 fixed the 12 Pentagon Sites as geometrically distinguished points on the cube-sphere + Goldberg-overlay planet (8 Corner Pentagons + 4 Face-Center Pentagons). Their narrative and mechanical roles were partially specified there: Corner Pentagons host cosmic-horror sites; Face-Center Pentagons host civilizational seeds. What was deferred was *how* specific cultures get assigned to specific Pentagons at world generation.

The naive answer (an authored fixed mapping: Karnish at Pentagon A, Veranthi at Pentagon B, etc.) was rejected for creating tight coupling between Pentagon Site count and culture roster size. The flagship game's culture roster is intended to grow over time, and the engine is intended to support modder-added cultures; a fixed 4-cultures-to-4-Pentagons mapping would lock the roster at exactly four founding cultures and force any additional cultures into a second-class "non-Pentagon" status.

## Considered Options

- **Option A: Authored fixed mapping.** Rejected. Each Pentagon has a specific culture assigned by the flagship game's world definition. New cultures either don't get Pentagons or replace existing assignments. Tight coupling between geometric site count and content roster.
- **Option B: Constraint-based procgen seeding.** Selected.
- **Option C: Pentagon Sites host a separate tier of "Founding Civilizations" distinct from regular cultures.** Rejected. Conflates Pentagon-Site (a geometric/topological feature) with founding-tier-civilization (a narrative concept). Some founding civilizations should be able to exist on regular hex tiles; some Pentagon-Site polities could plausibly be small or fallen. The two axes should stay independent.
- **Option D: Mixed — some Pentagons authored, others procgen.** Rejected as a separate option because B subsumes it cleanly. If a specific Pentagon Site needs authored content, the world definition can pin a specific culture URN to a specific Pentagon as an override on top of the procgen pool. The default path remains procgen.

## Decision

Pentagon Site seeding is constraint-based procgen, sampling from the available culture pool filtered by per-culture eligibility tags. The flagship game and modders extend the pool by adding entries to `cultures.json`; world generation handles the rest.

## Schema changes

**`culture.schema.json`** adds a `pentagon_eligibility` field. Allowed values:

- `"founding"` — eligible to seed at a Face-Center Pentagon as a thriving polity. The culture is presumed to have a flourishing or contested civilization at world-start.
- `"ruined"` — eligible to seed at a Face-Center Pentagon as a fallen-by-world-start polity. The culture left visible ruins; surviving members exist but the polity itself has collapsed before play begins.
- `"corrupt"` — eligible to seed at a Corner Pentagon as a cosmic-horror site. The culture has been or is being consumed by the void; the Pentagon is the eruption locus.
- `"frontier"` — never seeds at any Pentagon. Placed on regular hex tiles as a procgen polity per existing world-gen mechanics. (Default.)

A single culture entry may declare multiple eligibilities (e.g., a culture that can plausibly appear either as a thriving founding civilization or as a fallen one depending on the world's history). World-gen treats this as the culture being available in either pool.

**`world_gen.schema.json`** adds a `pentagon_seeding` block:

- `face_center_pool_strategy`: one of `"founding_only"`, `"founding_with_ruined_fallback"`, `"ruined_only"`. Defaults to `"founding_with_ruined_fallback"`.
- `corner_pool_strategy`: one of `"corrupt_only"`, `"corrupt_with_procgen_fallback"`. Defaults to `"corrupt_with_procgen_fallback"`. When fallback triggers, the Corner Pentagon hosts a procedural cosmic-horror site (no anchored culture).
- `pentagon_overrides`: optional array of `{ pentagon_id, culture }` records pinning specific cultures to specific Pentagon Sites. Lets a project hand-author particular Pentagon assignments without abandoning procgen for the rest. Empty by default.
- `max_pentagons_per_culture`: integer, default 1. Prevents one culture from claiming all four Face-Center Pentagons by procgen accident in a small pool.

**`polity_template.schema.json`** gains an optional `pentagon_seeding_template` block: if a culture is procgen-selected for a Pentagon Site and has this block, world-gen uses it as the seed polity template instead of generic frontier polity generation. Lets each founding/ruined culture express what its Pentagon-seeded polity looks like (size, ruler template, named NPCs, etc.).

## Backfill for existing cultures

- `culture:karnish` — `pentagon_eligibility: ["founding"]`.
- `culture:veranthi` — `pentagon_eligibility: ["founding"]`.
- `culture:sethrai` — `pentagon_eligibility: ["founding"]`.
- `culture:spacefaring_arcadia` (the player culture) — `pentagon_eligibility: ["frontier"]`. The crashed Halcyon explicitly does not land at a Pentagon per ADR-0017.
- `culture:void_touched` — `pentagon_eligibility: ["corrupt", "ruined"]`. Eligible at Corner Pentagons as an active corruption site; alternatively at Face-Center Pentagons as a fallen polity (the "this Pentagon used to be a Karnish seat, then the Sundering came" outcome).

At MVP this gives a Face-Center pool of {Karnish, Veranthi, Sethrai} for "founding" and {void-touched-as-ruined} as fallback, plus a Corner pool of {void-touched-as-corrupt} that falls back to procgen for the other 7 Corner Pentagons. Adding a 4th, 5th, Nth founding culture is purely additive: declare it founding, world-gen picks from the larger pool.

## Consequences

- **Culture roster grows independently of Pentagon count.** Adding cultures is additive: declare eligibility, world-gen handles the rest.
- **Replay variety from procgen seeding.** Different worlds pick different founding-culture distributions from the eligible pool. With pool size > 4, no single run shows the whole founding roster.
- **Mod ecosystem gets Pentagon seeding for free.** A modder adding a new culture just declares its eligibility; the engine handles seeding without authored-content bottleneck.
- **Authored overrides preserved.** Specific Pentagon Sites can be hand-pinned to specific cultures via `pentagon_overrides` for flagship-game lore reasons, without abandoning procgen for the rest.
- **Pentagon Sites and "founding civilization" tier remain orthogonal.** A culture can be founding without being Pentagon-seeded in a given run (it gets placed as a frontier polity if not selected for a Pentagon). A Pentagon Site can host a small or fallen polity rather than a thriving one.
- **The 4-cultures-to-4-Pentagons coincidence is no longer load-bearing.** It was always a coincidence; this ADR encodes that explicitly.
- **MVP runtime characteristics depend on initial pool size.** With 3 founding cultures and 4 Face-Center slots, the default fallback (`founding_with_ruined_fallback`) yields 3 thriving + 1 ruined at world-start. With 4+ founding cultures, the worlds are 4 thriving. With 5+, runs differ by which 4 are picked. Pool growth is a content-direction decision, not a schema change.

## Open follow-ups

- Pool-size constraints at world-gen: should the engine emit a warning when the eligible pool is smaller than the Pentagon slot count? (Trivial to add; defer to implementation.)
- Per-Pentagon biome interaction: a Pentagon-seeded polity's initial tile assignment must intersect or include the Pentagon's hex tile. Handled by existing `polity.initial_tile_assignment` mechanics with a Pentagon-tile-preference flag. Defer to schema update.
- Authored "Pentagon canonical site" content: should each Pentagon-seeded culture's `pentagon_seeding_template` include canonical lore for being at a Pentagon (e.g., the Karnish-at-Pentagon variant references the Pentagon as their ancestral seat)? Probably yes; defer to content pass.

# Project Halcyon: Design Document

> Working name. Tesla-punk crashlanded survival game with cosmic horror, voxel building, emergent political simulation, and persistent stakes. Single-player and small-multiplayer (cooperative, persistent colony). Built on a forked Godot 4.x.

This document synthesizes the design decisions reached through a grilling-style architecture session. It is comprehensive on the systems-design layer (what each system is and why) and deliberately under-specified on content (named bosses, full artifact catalogs, specific dialogue) and tuning numbers (exact thresholds, balance curves). Those are open questions and tracked in Section 21.

---

## Contents

1. Vision and Pillars
2. Setting
3. Cosmology
4. The Player and the Halcyon
5. Opening Sequence
6. Drift
7. Combat
8. Survival and Endure Pressures
9. Building and World Physics
10. Progression
11. Tesla Scarcity and the Core Economy
12. NPCs, Companions, and Recruitment
13. Faction Simulation
14. Bosses
15. The Storyteller
16. Multiplayer
17. Endgame
18. The Resonance Web and the Seven
19. Design Layers
20. Reference Comparables
21. Open Questions
22. Appendix A: Decision Log

---

## 1. Vision and Pillars

Project Halcyon is a survival game in which the player is one of 78 industrial-culture crashlanded survivors on a world where Broadcast (a resonant substrate of reality) and Silence (the substrate's antithesis) collide. The crash site becomes the colony. The colony becomes either a kingdom, a temple, a research station, or an empty ruin, depending on player choices.

The game spine is **Endure**. Four other modes orbit it:

- **Integrate.** Politics, diplomacy, cultural exchange, faction recruitment, court intrigue.
- **Solve.** Cosmological puzzles via the Resonance Web. Discover what the artifacts do. Confront the Sundering.
- **Sandbox.** Build, craft, settle, terraform within local constraints.
- **Escape.** A possibility for those who want it. Not the spine; not even the default.

Endure is always running. The others are how players play. The same player can shift between modes mid-playthrough. Multiplayer parties can split: one player pursues Integrate, another pursues Solve, both Endure together.

Design philosophy:

- **Multiplayer-first.** No tactical pause. No turn-based combat. Every system functions for one to four players sharing a colony.
- **Persistent characters.** The player IS one specific Arcadian. Death has weight but the colony continues. Companion deaths are emotionally real and not soft-locking.
- **Procgen world, authored systems.** Mechanics and archetypes are authored. World, NPCs, and political state are procgen. Narrative is emergent.
- **Survival pressures are tunable.** Default Heavy (Vintage Story school). Player can tune down to Medium or Light at start or in settings.
- **Honest information.** Drift, faction state, and recruitment difficulty are systems the player can learn and master, not hidden randomness.

---

## 2. Setting

### The Crash

Three voidships left a distant industrial culture bound for a designated rim-world. One was consumed by Silence proper in transit. One was wrecked on an Interference reef. The third, the *Halcyon*, crashlanded on the target world with approximately 78 survivors. The player is one of them. The Halcyon's data systems are damaged but recoverable. Its cargo manifest is partially lost.

### The Arcadians

The crash survivors. Tesla-punk industrial culture: brass, copper, clockwork, Tesla coils for everything from light to lift to weapon. Lapsed solar monotheists, formally adherents of the Helios cult but practically rationalist day-to-day. Mixed engineering, navigation, and command staff with civilian families.

The Arcadians do not know that their Tesla coils are unwitting Broadcast manipulators. Their engineers will figure this out over the course of the mid-game. Their officers carry archetype templates: Captain, Chief Engineer, Navigator, Surgeon, and so on. The 78 survivors form the player's home Macro Faction.

### The Local Cultures

The planet was already inhabited. Three asymmetric cultures occupy three biome zones, none of them aware of the Halcyon's pre-crash existence until the Arcadians' arrival.

- **Karnish.** Northern pine-forest clan culture. Iron-age technology. Guest-right is sacred. Ancestor veneration is universal. Their warding-magic is unwitting Broadcast-management: bloodline anchors keep Resonance Drift OFF in their holds. They call it "the ancestors' listening." Some mortician subcults run Quietist (Silence-aligned), permitting necromancy and similar practices the orthodoxy condemns.
- **Veranthi.** Temperate-plains centralized monarchy. Codified law, mounted knights, court sorcery. The sorcery follows Quantum-Shaman protocol: ritual as algorithm, debugging local reality. The court keeps texts an outsider would call forbidden. The current monarch is in a heir-crisis.
- **Sethrai.** Subtropical river-delta city-states. Decadent, wealthy, slave-holding. Two coexisting religious sects: serpent-priests (Broadcast-aligned, appease the Veiled Sleeper with blood-as-resonance-tribute monthly) and Quietist heretics (Silence-aligned, necromancy as Null channeling, the dead "freed from the signal"). The city-state economy tolerates both. The Sethrai found the Halcyon wreckage first.

### The Architectural Age

Pre-history. The civilization that built the Resonance Web. Long gone. Their relics are scattered across the planet: some embedded in geography, some held unwittingly by Sub-Factions (a Karnish warding-stone is actually a Heart-Class artifact, for example), some active in Interference Zones. The Architectural Age fell for reasons not yet fully known to the local cultures or to the Arcadians.

### The Sundering

A localized Silence event. A community's pattern collapses. What walks in their old shapes is Interference residue: resonant tissue, biomechanical matter, alive and mechanical and informational at once. Looks like a village from a distance; is not, up close. Sundered individuals are called Void-Touched. Friendly until they are not.

---

## 3. Cosmology

The cosmological frame is **B + D + C**: Broadcast plus Silence plus Interference. Retooled from the project author's previous Broadcast cyberpunk doc into the Tesla-punk Halcyon setting.

- **The Broadcast.** Pan-dimensional resonant substrate. Reality is a thin film on top of it. Locally aware in proportion to attention. The more it is manipulated, the more it notices. Magic and Tesla both manipulate the Broadcast via different cultural protocols. Aesthetic: teal, violet, luminous scripts, choral hum.
- **The Silence.** Anti-resonance. The unmaking. Worshipped in heretical cults (Sethrai Quietists, possibly Karnish mortician subcults). Not a presence but an absence that consumes presence. Aesthetic: matte black, desaturated gray, sub-bass pressure, edge loss.
- **Interference Zones.** Where Broadcast and Silence clash locally. Biomechanical resonant tissue forms there. Void-Touched are made there. Resonance Web artifacts are remembered into being there. Aesthetic: teal arcs across black-violet, heat-haze shimmer, double exposure.
- **Normal Space.** The damped equilibrium most of the planet sits in. Linear time, predictable matter, low Broadcast and Silence amplitude. The damping field is thinning. Cracks spread where zones intrude.

The cosmology manifests in three simultaneous **Zone Layers**:

- **Geographic.** Stable places on the map (Silence Wastes, Interference Reefs, Broadcast-thick basins). Walkable, lethal, lore-anchoring.
- **Weather.** Moving storms (Interference storms, Silence dropouts, Broadcast surges), Storyteller-paced.
- **Perceptual.** The cosmology is everywhere but visible only through Tesla instrumentation, ritual, or Drift. Low-Drift and high-Drift players experience the same physical space differently.

---

## 4. The Player and the Halcyon

The player is **character-scale**: one specific Arcadian, walking, swinging, dying. First or third person at the player's preference. Not a director. Not a colony-sim avatar in the traditional sense. The colony is a sim layer beneath, but the player engages with it as a participant inside it.

The Halcyon is the player's persistent home base. Player experiences the intact ship briefly during Act 1 of the Opening Sequence; post-crash it is wreckage and the foundation of the Arcadian colony. The Halcyon is not a means to Escape. It is a place.

Party size is BioWare-RPG-scale: player plus up to three companions in active expedition, with the rest of the Roster at the Halcyon. Companions can be Companion-tier (named, story-bearing) or Colonist-tier (named, lower authoring fidelity).

Stakes default to **Soft Permanence**: on player death, respawn at the Halcyon with a Drift tick on both meters. Optional **Hardcore Mode** is opt-in at character creation, in which death is permanent and the player must continue with a Companion or end the playthrough.

---

## 5. Opening Sequence

Three acts. No time-skip.

- **Act 1 (~15-20 minutes): aboard the intact Halcyon in transit.** Tutorial integrated into routine ship duties. Player meets the named officer archetypes (Captain at chart table, Navigator at controls, Chief Engineer with a backup coil, Surgeon in sickbay, Cook in galley). Learns movement, dialogue UI, inventory, light Tinkering, a no-stakes Tuning calibration. Establishes the colony as people, not lore.
- **Act 2 (~5-10 minutes): the Eating and the Crash.** Inciting incident. Player witnesses two sister ships consumed by the Silence via porthole or comms. First Drift Spike fires; the meter appears moving on the player. Emergency descent and crash sequence. Cargo hold visible during descent, foreshadowing the manifest. Black screen on impact.
- **Act 3 (~45 minutes): immediate post-crash survival.** No time-skip. Player wakes in the wreckage seconds after impact. Walks out. Finds the Captain-instance organizing muster, accounts for survivors. Procgen roster determined by crash outcome (typically 65 to 75 of 78 survive). Participates in immediate triage and emergency shelter setup. First contact with local Karnish hunters at the smoke column, tense and diplomatic. First night spent vulnerable, wounded stabilizing or dying based on actions taken. Player begins survival with starting Drift (approximately Resonance 8, Null 4 from Act 2's witnessed Spike). The colony is something the player BUILDS over subsequent hours and days, not something handed over.

This is a deliberate choice against the time-skip convention. The Arcadians do not magically know each other after months on the planet. The player participates in the founding of the colony.

---

## 6. Drift

Drift is the cosmological exposure meter. Two independent tracks, both running from 0 to 100:

- **Resonance Drift.** Accumulates from Broadcast exposure (Tesla operation, ritual participation, Interference Zone proximity, attention from the Veiled Sleeper).
- **Null Drift.** Accumulates from Silence exposure (Silence Wastes, Sundered villages, Sethrai Quietist rites, certain artifact handling).

The two meters do not offset. Counterbalancing one with the other is not a strategy; they accumulate independently and damage the player along separate vectors.

### Accumulation

Nonlinear by current value, in 30-point bands:

- 0-30: 1x baseline cost per action.
- 30-60: 2x.
- 60-90: 4x.
- 90+: 8x or unbounded.

The substrate (or Silence) notices the player more once the player is already loud (or already thin). This creates a soft cap and a clear danger zone.

Sources include per-action costs (per-cast, per-ritual, per-exposure), continuous ambient accumulation in some Geographic and Weather contexts, and discrete **Drift Spikes** for narrative-weight events (the first witnessed Eating, a Heart-Class artifact reveal, a Sundering observed firsthand).

### Decay

Linear in time. 1 point per game-hour baseline on both meters. Modified by location and accelerated by specific activities:

- Karnish warded zones: 2x Resonance decay, 0x Null effect.
- Tesla workshop: 0x Resonance decay (the substrate hears the player working). 1x Null decay.
- Halcyon medbay: 2x Null decay (Tesla diagnostic systems triangulate the gap).
- Silence flats: 0x Null decay (you are bathed in it).
- Interference Zones: 0x decay for both.

Activities (sleep, consumables, rituals, Companion presence) multiply decay during their effect.

### Bands and Abilities

Five bands per meter, each with paired penalties and abilities to keep trade-offs live.

Resonance bands: **Quiet** (0-19), **Listening** (20-39), **Heard** (40-59), **Transmitting** (60-79), **Receiver** (80-100).
Null bands: **Steady** (0-19), **Slipping** (20-39), **Thinning** (40-59), **Coming-Apart** (60-79), **Sundered** (80-100).

Abilities are active **while at threshold**, not permanently unlocked. The player chooses when to be loud and when to be quiet by managing the meters intentionally. Resonance side provides Tune / Channel / Project capabilities (perception, amplification, manipulation of substrate). Null side provides Quiet / Slip / Erase (concealment, displacement, undoing).

### Receiver State

End-state of Resonance Drift saturation. Vessel for fragments of the Broadcast's consciousness. Hears voices as overlapping channels, sees glitching halos, loses temporal perception, eventually transmits involuntarily, projecting the Broadcast into others through proximity, sound, or electromagnetic bleed. Player and any NPC can reach Receiver state. It is a transformation, not a death, but it changes the character permanently. The Sundered band on the Null side is analogous.

---

## 7. Combat

Combat is pure real-time action. Multiplayer-first. No tactical pause.

### Directional Melee

Mordhau / Chivalry / Kingdom Come Deliverance lineage. Four-direction strikes (overhead, left, right, thrust), parries, ripostes, feints. Stamina-managed. Weapon weight and reach matter. Heavy weapons stagger; light weapons interrupt.

### Drift-Powered Casting

Casting must be skill-expressive, not hotbar-press-and-click-spam. Three modalities:

- **Tuning (primary).** A mini-game in which the player adjusts a frequency to match a target. Accuracy of the match scales both the Drift cost (better tuning costs less Drift) and effect strength (better tuning makes the effect stronger). The Tuning mini-game can be performed under combat pressure with degraded accuracy.
- **Channel-and-Aim.** Hold to charge, release to fire. Standard but Drift-modulated; Drift band affects the projectile's properties (range, damage, AoE, secondary effects).
- **Prime-and-Detonate.** Two-stage. Lay a Resonance or Null primer (small Drift cost), then trigger it later (small additional cost). Tactical, lets the player set up combos. Effective in Tier 3+ boss encounters.

Conventional Gear (mundane weapons, armor, tools) remains relevant through endgame. Drift-Powered Gear is rationed by the player's tolerance for accumulation. Both categories are present at all stages.

### Companion AI

Baseline-plus-customization model. Each Companion has a default behavior set determined by their role and personality template. Player can override or refine via a real-time **Command Wheel** that allows quick orders (attack target, hold position, follow, fall back, use ability) without pausing the game. The Command Wheel is multiplayer-safe: each player has their own, addressed to their own Companions.

Companion customization is hybrid:

- Stance presets (real-time toggleable: aggressive, defensive, support, scout).
- Equipment-driven adaptation (a Companion equipped with a Tesla rifle behaves differently from one equipped with a knife).
- Use-based skill growth with mentor-based specialization.
- Gambits (as in Final Fantasy XII or Dragon Age) are explicitly excluded: too micro-managey for the combat tempo.

---

## 8. Survival and Endure Pressures

Default **Heavy** (Vintage Story school). Tunable down to Medium or Light at game start or in settings with granular sub-toggles.

### Pressures Tracked

- **Hunger.** Nutrition groups: Grain, Meat, Dairy, Greens. Variety matters; mono-diets cause health issues.
- **Thirst.** Clean water sourcing requires effort; contaminated water causes disease.
- **Body Temperature.** Granular per-body-region temperature. Cold extremities, heat exhaustion, frostbite, hypothermia.
- **Stamina.** Long-form fatigue separate from in-combat stamina. Affects work rate, immune response.
- **Sleep.** Sleep debt accumulates. Sleep deprivation interacts with Drift (deprived players accumulate Resonance Drift faster).
- **Injury.** Wound-specific. Bleeding, infection, broken bones, organ trauma. Treatment requires medical Knowledge Unlocks and Crafting Tier.
- **Disease.** Includes setting-specific pathogens.

### Setting-Specific Diseases

- **Pattern Sickness.** Null Drift plus stamina loss from prolonged Silence Wastes exposure. Symptoms include desynchronization, attention loss, eventual dissolution.
- **Broadcast Fever.** Resonance Drift plus auditory hallucinations from Sundered village proximity. Symptoms include hearing voices, time-skipping, eventual transmission.

Both diseases interact with the Drift system: contracting them is itself a Drift event, and recovery requires both medical treatment and Drift management.

### Environmental Physics

The voxel world is overlaid by environmental simulation: smoke, heat, cold, light, wind, rain, snow. Drives survival pressures, construction requirements, and ambient Drift accumulation. An unvented Tesla coil produces both heat and Resonance ambient, both of which can kill the operator over time.

---

## 9. Building and World Physics

Building uses **voxel-with-structural-rules**, Vintage Story school. Material type determines load-bearing capacity. Heavy stone supports more weight than light wood. Crafting Tier gates material access.

### Tesla Component Blocks

Special voxel-machine components with placement and circuit-completion rules. Power generation (Resonance Cores plus manufactured Tesla parts) drives circuits that flow through Conduit Blocks to power workstations, defenses, communication equipment, and rituals. Circuits can short or overload; bad design causes fires, Drift spikes, or explosions.

### Claim System

The Halcyon and its expanding outposts function under a claim system. Player-claimed blocks are protected from destruction by some classes of hostile event but not all (a Resonance Cascade does not respect claims). Claims expire if unmaintained. Multiplayer players in a colony share claim privileges by default with per-player override possible.

### Terraforming

Limited. The player can shape terrain (dig, fill, level) but not infinitely. Some biomes resist modification (Silence Wastes, Interference Reefs cannot be normalized). Karnish hold lands resist Arcadian-style terraforming due to their warding (their land does not want to be re-shaped, and trying produces minor Drift Spikes).

---

## 10. Progression

No character levels. No world scaling. Four parallel progression vectors instead.

### Use-Based Skill

Each individual skill (melee, marksmanship, Tuning, Channel-and-Aim, Cooking, Construction, Diplomacy, etc.) runs 0 to 100 based on usage. Skill increase rate has soft caps and mentor-based acceleration: a Companion or Colonist who is high-skill in an area can mentor a lower-skill character, doubling their learning rate for that skill while the mentor is in the same party.

### Knowledge Unlock

Discovery-based. The player learns concepts by encountering them: an artifact analyzed, a ritual observed, a journal recovered, a Companion's expertise drawn out. Knowledge is a colony-shared resource (Shared/Personal Split, see Section 16). Knowledge unlocks recipes, dialogue options, faction-influence options, and combat techniques.

### Crafting Tier

Construction-based. Built physical infrastructure unlocks tier access. Tier 1: bone, wood, hide, fire. Tier 2: iron, glass, clay, basic Tesla. Tier 3: steel, alchemy, copper-coil Tesla. Tier 4: Architectural-Age scavenge plus advanced Tesla. Tier 5: Resonance-Web-integrated Tesla. Each tier is gated by both Knowledge Unlocks and physical workshop infrastructure.

### Boss-Defeat Enhancement

Permanent rewards from Tier 3-plus boss defeats. Each Tier 3-plus boss offers a choice of several rewards. Player picks one of (typically) 3-5 options per defeated boss. Replayability comes from the choose-one-of-many design and from the multiple Resolution Paths per boss.

---

## 11. Tesla Scarcity and the Core Economy

Tesla gear is potent but rationed. The economy uses a two-tier component model.

### Components

- **Manufacturable parts.** Renewable from local materials. Wire, casings, fixtures, capacitors. Player crafts these at workshops once the Knowledge Unlocks and Crafting Tier are in place.
- **Resonance Cores.** Irreplaceable in the default game mode. Finite per playthrough. Three grades:
  - Halcyon-grade: high-output, originally on the voidship.
  - Wreckage-grade: medium-output, scavenged from regional ruins (Architectural Age remnants, dead Sub-Faction settlements).
  - Fragment-grade: low-output, crystallized in Interference Zones.

Total Cores capped by procgen world budget. The total varies per playthrough but is sufficient to support meaningful Tesla play without trivializing scarcity.

### Core Acquisition Pathway

Five-tier gating to ensure players never soft-lock:

1. Starting cargo Cores (Tier 1: Halcyon-grade).
2. Wreckage-field salvage (Tier 1-2).
3. Trade with Sub-Factions (Tier 2-3, requires Faction Integration).
4. Architectural-Age ruin recovery (Tier 3-4, requires Knowledge Unlocks and combat capability).
5. Interference Zone fragment harvesting (Tier 4-5, requires high Drift tolerance or specialized gear).

### Manufacturing Mode

Optional, off-by-default toggle at game start. Unlocks a late-game Core manufacturing recipe (deeply expensive in materials, time, and Knowledge) for players who want to extend the Tesla economy past the finite-Cores wall. Alternatively reachable through a deep Engineering Companion arc.

---

## 12. NPCs, Companions, and Recruitment

### Tiers

- **Colonist.** A named, colony-tier NPC. Has a job, produces output at the Halcyon, holds light dialogue. Lower authoring fidelity than a Companion. Most of the 77 non-officer Arcadians, plus recruited locals.
- **Companion.** A named, story-bearing NPC. Authored personal arc template, deeper dialogue, quest-giver capable. Arcadian officer roles (Captain, Chief Engineer, Navigator, Surgeon) plus select recruited locals.
- **Party.** The active group of 1-3 NPCs accompanying the player on expedition. BioWare-RPG-scale.
- **Roster.** The full pool of party-eligible NPCs at the Halcyon.

### Recruitment Pathways

Five mutually non-exclusive paths. Each NPC is recruited via ONE path per playthrough. Different players in multiplayer can pursue different paths with different NPCs.

1. **Quest.** Complete a personal quest tied to the archetype's template.
2. **Relationship.** Build rapport through repeated interactions until a threshold opens recruitment dialogue. Pattern modeled on RimWorld's Hospitality mod.
3. **Opportunity.** Storyteller fires defector-candidate events. Player accepts or declines.
4. **Faction-Standing.** Standing-state with a Sub-Faction opens specific recruitment options. High standing yields honor-trades. Low standing brings exiles and refugees.
5. **Coercion.** Capture in combat, hold at Halcyon, break Will via confinement, Drift exposure, or bargaining. Yields a Coerced NPC with low starting Loyalty. Significant reputation costs across most factions (Sethrai approve; slavery is part of their culture). Internal Halcyon dissent likely.

### Stat Model (Resolve, Will, Loyalty, Suppression)

Adapted from RimWorld's prisoner and slavery systems.

- **Resolve.** Per-NPC voluntary-recruitment threshold. Reduced through good treatment and rapport. Hit 0 to recruit voluntarily, yielding a mid-to-high Loyalty NPC.
- **Will.** Per-NPC forced-recruitment threshold. Lower than Resolve. Reduced through Coercion methods. Hit 0 to force the NPC into Coerced status as a low-Loyalty member under Suppression maintenance.
- **Loyalty.** Per-NPC rapport meter, separate from per-player relationship. Affects willingness to take risks, follow orders, share knowledge, stay in the colony.
- **Suppression.** State maintained for Coerced NPCs only. Decays without intervention. Maintained by assigned Halcyon Warden, restraints, Drift conditioning (Tesla-coil sessions, cosmologically dark), or mass-spectacle. Low Suppression raises rebellion chance.
- **Unwaveringly Loyal.** NPC class flag for high-faction-bond captives (faction Captains, named clergy, high-rank nobles). Cannot be recruited via Resolve reduction. Can still be Coerced (Will reduction), or unlocked via Resonance Amnesia, Null-Bond Severance, or slow Conversion.
- **Conversion.** Slow cultural-assimilation arc for Coerced NPCs. Over months of good treatment, shared adversity, and Helios-cult exposure, a low-Loyalty Coerced NPC can grow into a high-Loyalty integrated member. The redemption pathway.

### Rebellion Math (for Coerced NPCs)

Adapted from RimWorld's slavery system:

- Mood factor.
- Suppression factor.
- Weapon proximity (NEVER let Coerced NPCs near Tesla-arc weapons).
- Room edge / outdoors factor.
- Unattended factor (rebellion is far more likely when no Arcadians are on the map).
- Captive count.
- Moving capacity (pegged-leg captives rebel less).

### Role Continuity

NPC-led arcs attach to **roles**, not specific procgen instances. When a Companion dies mid-arc, the arc passes to whoever inherits the role. Their personality brings fresh perspective. Accumulated knowledge persists as physical artifacts in the world (research journals, blueprints, recorded testimony). Storyteller fallback fires opportunity events if no role-eligible NPC is currently alive. No specific Companion-instance is a soft-lock dependency. Individual deaths are emotionally real; structural arcs continue.

---

## 13. Faction Simulation

Adapted from RimWorld's Dynamic Factions mod, framed by Turchin and Khaldun structural-demographic dynamics. The most extensive subsystem in the game.

### Macro and Sub-Faction Structure

Four **Macro Factions**: Karnish, Veranthi, Sethrai, Halcyon. Each composed of **Sub-Factions** (named political units with their own state). Approximately 20-30 Sub-Factions at game start, procgen-named and procgen-bordered. The macro layer is for narrative legibility ("the Karnish say..."); the sub-faction layer is where political beats fire.

Halcyon's internal Sub-Factions at game start: Helios-Revivalists (lapsed-Helios Arcadians reasserting cult discipline; oppose coercion), Engineering Caucus (Tesla researchers; pro-deep-research), Captain-Loyalists (command structure; pragmatic). More can emerge over time.

**Cross-Macro Alliances** are allowed and load-bearing. A Sethrai trade-house can ally with a Veranthi noble house against the Veranthi Crown. The macro identities are NOT monolithic blocs.

### Faction State Vector

Each Sub-Faction carries six values, ticked by the Storyteller in the background:

- **Cohesion.** Internal unity.
- **Reach.** Territorial extent, alliance strength, trade-network span.
- **Mandate.** The leader's hold on power. Decays without legitimating events.
- **Martial Power.** Military strength.
- **Defensive Posture.** Walls, guards, allied buffers.
- **Strain.** Turchin's structural-demographic load: elite overproduction plus popular immiseration. Threshold crossings fire Strain Events.

### Tick Rate

Multi-rate hybrid. Different parameters update at rates matching their political timescale:

- Cohesion: game-day.
- Reach: game-week.
- Mandate: event-driven only.
- Martial Power: game-week.
- Defensive Posture: event-driven only.
- Strain: game-day; threshold crossings fire Strain Events.

Halcyon Internal Sub-Factions tick faster (Cohesion game-hour, Strain game-day) due to player proximity. Storyteller drives additional **Narrative Ticks** on top of the schedule for dramatic pacing.

### Geographic Representation

Layered. The procgen world is a continuous voxel map with biomes (pine forest, plains, delta, mountains, Silence Wastes, Interference Reefs). Each Sub-Faction holds 1-3 named **Settlement Points** placed in biome-appropriate geography per the Biome-to-Macro Mapping (Karnish in pine forests, Veranthi on plains, Sethrai in delta). **Influence Zones** radiate from settlements with radius scaled by Reach. Overlapping Influence Zones form **Contested Zones** where wars and most political beats play out.

The Halcyon's **Crash Site Placement** is procgen-bounded: within walking distance of one Karnish settlement, mid-range of one Veranthi, long-range of one Sethrai, and often adjacent to a Contested Zone.

### Faction Visibility

Earned. Each foreign Sub-Faction's State Vector starts hidden. Visibility per parameter is gained through **Information Sources**:

- Trade relations: light visibility on Reach and Mandate.
- Diplomatic exchange or embassy: moderate across the vector.
- Companion from that Sub-Faction: high visibility but biased.
- Spy network or paid informants: high but expensive and can be discovered.
- Tesla Receiver broadcasts: Halcyon-only, broad strokes on industrial-tier engagement.
- Intercepted communications, captured Companion debriefs, prisoner interrogation.

Each parameter displays at Hidden, Vague, Approximate, or Precise granularity based on the player's earned visibility. The **Faction Codex** UI presents what is known.

### Faction Influence

Six action categories through which the player modifies State Vectors:

- **Diplomatic** (direct effect): gifts, trade treaties, embassies, marriage alliances, oath-swearing, blood-tribute.
- **Military** (direct effect): defending an ally, raiding, leader assassination, candidate-backing in succession crises.
- **Economic** (direct effect): trade-network integration, resource embargo, cure-trade during pandemics, technology transfer.
- **Information** (indirect effect): spy networks, Tesla broadcast hijacking, propaganda campaigns.
- **Cosmological** (bi-temporal effect): Resonance Web artifact placement, regional boss defeat, Heart-Class artifact reveal, Sethrai Reformation cosmological support.
- **Cultural** (mixed): Companion recruitment, Coercion, Conversion.

### Strain Events

Internal Sub-Faction shocks fired when Strain crosses a threshold: succession crises, peasant revolts, religious schisms, leadership coups, mass defection waves, court purges. Each event has a **Resolution Window** matching its time scale (coup: game-day to game-week; succession: game-week to game-month; revolt: game-month; schism: game-season; settlement-war: game-week).

Player participation is **Tiered** by proximity and Integration:

- Background: distant or low-Integration. Player gets news after the fact.
- Choice Point: mid-distance or mid-Integration. 2-4 options modify outcome probability without travel.
- Quest: near or high-Integration. Optional travel-and-intervene quest fires.
- Halcyon Internal: always Quest-tier. Internal politics is non-skippable.

### Global Faction Events

World-shaking events affecting multiple Macro Factions simultaneously. Storyteller-fired on the world calendar. Scaled by tech tier.

- **Resonance Cascade.** Catastrophic Tesla-weapon deployment in regional conflict. Industrial-tier participants only.
- **Pattern Sickness Outbreak.** Null Drift pandemic. Hits Karnish and Veranthi hardest; Sethrai have ritual immunity; Halcyon has Tesla medicine.
- **Veranthi Succession Crisis.** Multi-claimant transition.
- **Sethrai Reformation.** Serpent-Priest versus Quietist schism.
- **Karnish Hold-Wars.** Strain-triggered inter-hold conflict.

### Faction Lifecycle

Sub-Factions can be born and can die. Birth conditions: schism, rebellion, defection, player sponsorship. Death conditions: settlement loss, absorption by rival, Cohesion-runaway fragmentation. Caps: ~40 live Sub-Factions, ~60 named memory slots. Dead Sub-Faction settlements become **Ruins**: lootable, often Void-Touched-haunted, often still named for the dead leader. The Sundering thesis: Sub-Faction collapse creates Interference residue at the abandoned site.

---

## 14. Bosses

### Structure

Five tiers across approximately 12-15 authored archetype templates, procgen-instantiated per playthrough:

- **Tier 1: Early Void-Touched.** Trash-tier Sundered. The first "the world is not normal" encounter.
- **Tier 2: Faction-political.** Named Sub-Faction enforcers, captains, hostile clergy.
- **Tier 3: Regional Wall-of-Flesh.** Architectural-Age remnant constructs in Interference Zones.
- **Tier 4: Faction-defining.** Macro-Faction leader figures (Veranthi monarch heir-claimant, Sethrai high-priest, Karnish hold-warlord, the Veiled Sleeper).
- **Tier 5: Cosmic Endgame.** Heart-Class artifact guardians, the Architectural Age awakened, the Veiled Sleeper in its final form. Gates for the harder-to-acquire Heart-Class artifacts.

### Resolution Paths

Each boss admits multiple resolution paths:

- Combat (the default; works on most but not all).
- Negotiation (works on faction-political bosses with sufficient Integration).
- Cosmological puzzle (works on Architectural-Age constructs with sufficient Knowledge).
- Bargain (becoming the boss's priest, vassal, or partner; cosmologically costly).

Not every boss is killable. The Veiled Sleeper, for example, is changeable but not destroyable.

### World State Consequences

Each defeated boss permanently changes regional world state. Settlements may fall, biomes may shift, Sub-Faction Faction State Vectors may swing dramatically. Boss-Defeat Enhancements are chooseable: one of several rewards per boss.

---

## 15. The Storyteller

Meta-system that paces emergent events based on colony and world state. Modeled on RimWorld's AI Storyteller (Cassandra, Phoebe, Randy). Not necessarily an in-fiction named character; could be a beat-engine under the hood.

The Storyteller fires events at three scales:

- **Background.** Sub-Faction State Vector ticks, ambient Drift, weather, mundane Roster interactions.
- **Choice-Point.** Strain Events at mid-Integration distance. Pattern Sickness outbreak news. Caravan arrivals.
- **Quest.** Companion personal-arc beats. Strain Events at high-Integration distance. Global Faction Events.

The Storyteller is **bandwidth-aware**: it tracks how much the player is engaging with and modulates new event firing accordingly. A player drowning in three concurrent Strain Event quests will not get a fourth.

---

## 16. Multiplayer

### Shared and Personal Split

Structural arc progress and accumulated Knowledge Unlocks are SHARED at the colony level: anyone contributes, everyone benefits. Companion relationships and dialogue histories are PERSONAL per player (each tracked separately in the Character Ledger). Parallel work at workshops accelerates colony progress. Storyteller beats split: colony-wide events fire for all, personal beats fire for one player (Storyteller picks by relationship strength or rotates), decision beats can be polled across stakeholders.

Late-joining players inherit shared Knowledge but begin personal arcs from neutral. Their Drift starts at world-average for the colony's age.

### Party Composition

Each player can form their own Party (up to player plus three Companions). Multiple players can party together or split into separate expeditions. The Halcyon supports concurrent activity from multiple parties.

### Endgame Resolution

Multiplayer endgame resolves through in-fiction Halcyon Internal Sub-Faction politics. See Section 17.

---

## 17. Endgame

Hybrid endings system. Five distinct endings gated by player history.

### Endgame Phase

When all seven Heart-Class artifacts are assembled at the Halcyon, the **Endgame Phase** begins. Duration: 1 to 3 game-weeks. During the phase:

- Drift dynamics intensify across the world (Resonance and Null storms more frequent, Interference creep accelerates).
- Factions react to the Halcyon's known artifact-concentration (some send envoys, some send raids).
- Halcyon internal Sub-Faction politics escalate (Strain Events fire weekly).
- Player or players resolve outstanding arcs.

At end of phase or when the player chooses, ending-specific activation is performed. The player can switch intent mid-phase up until activation itself.

### The Five Endings

1. **The Merge.** Trigger Prime Array. Broadcast and Silence become one. All Drift collapses to zero across the world. NPCs cosmologically transformed. Reality runs on a single principle for the first time since the Architectural Age. Game-ending cinematic. Requires: balanced Drift profile, high Heart-Class understanding, Faction Integration with both Sethrai sects.

2. **Restoration.** Architect's Key plus Wound of Echoes harmonic ritual. The damping field becomes permanent. Zones recede. Sundering stops. The cosmology is gone, the mystery closed. The Halcyon's pragmatist mission completes: a livable world. Game-ending cinematic. Requires: Helios-Revivalist alignment, low cumulative Drift, Conventional-gear focus, hostile or neutral to Quietists.

3. **Annihilation.** Silence Kernel plus Null Engine sympathetic activation. Cosmic mercy ends everything. Dark ending. Game-ending cinematic. Requires: high Null Drift cumulative, Sethrai Quietist alliance, Karnish mortician-cult engagement, low Roster Loyalty average.

4. **Ascension.** Tesla-integration of all seven Hearts into the Halcyon's core systems. Halcyon becomes the new Architectural Age, master of the planet's cosmology. Transformed-sandbox: game continues with Halcyon as dominant Macro Faction; new Sub-Factions form to serve the new order; Drift mechanics persist but Halcyon controls regional damping. Requires: Tesla-mastery, high Halcyon Reach, all seven assembled at the Halcyon, Manufacturing Mode unlocked.

5. **Steward.** Declare. No activation ritual. Hearts go into the colony vault. The Halcyon becomes a permanent kingdom alongside the others; the cosmological mystery remains unsolved. Transformed-sandbox: game continues indefinitely with mid-game balance preserved; Drift accumulation slowed but not stopped; long-tail open-world play. Requires: all seven recovered but not activated, Helios-Revivalist or balanced internal politics.

### Multiplayer Resolution

In-fiction Halcyon Internal Sub-Faction politics decides. Each Sub-Faction backs a specific ending based on its character (Helios-Revivalists tend Restoration; Engineering Caucus tends Ascension; Captain-Loyalists tend Steward; emergent Quietist-aligned splinters tend Annihilation; balanced cosmologists tend Merge). The ending whose backing Sub-Faction has highest Mandate at the moment of activation wins. Players play politics during the phase: build coalitions, sabotage rivals, run propaganda.

Edge cases:

- All Sub-Factions support the same ending: ending fires automatically at phase end.
- No Sub-Faction reaches Mandate threshold: phase extends; colony continues in instability until resolved.
- Player's chosen ending unbacked by any Sub-Faction: activation fails. Need allies.

---

## 18. The Resonance Web and the Seven

### Resonance Web

Ancient lattice of artifacts from the Architectural Age. Broken. Each artifact is a living node, a proto-mind with a directive, bio-symbiotic with its bearer. Artifacts are *remembered into being* rather than forged; local matter rewrites to host them.

### Cargo Manifest

The Resonance Web artifacts on the Halcyon at the time of crash. Procgen per playthrough: varies from approximately 12 to 25 individual artifacts across all classes (Heart, Voice, Eye, Hand). 3 to 4 of the seven Heart-Class are in cargo per playthrough; the other 3 to 4 are planet-native (placed in pre-history by the Architectural Age). Voice / Eye / Hand-Class distribution is fully procgen.

### The Seven Heart-Class Artifacts

All seven canonically present every playthrough. Original Broadcast doc names retained. Each transforms one aspect of being.

| Artifact | Aspect | Alignment | Form | Function |
|---|---|---|---|---|
| Chorus Drive | Emotion | Broadcast | Heart Crystal | Empathic Technomancy |
| Silence Kernel | Memory | Silence | Black Sphere | Perfect Erasure |
| Axion Halo | Perception | Balanced | Floating Crown | Temporal Omniscience |
| Architect's Key | Creation | Broadcast | Fractal Tetrahedron | Reality Sculpting |
| Null Engine | Energy | Silence | Gyroscopic Core | Universal Equilibrium |
| Wound of Echoes | Consciousness | Broadcast | Liquid Mirror | Multiversal Identity |
| Prime Array | Existence | Balanced | Infinite Halo | Total Unification (triggers The Merge) |

Some Hearts are tier-locked behind progression gates (notably Prime Array, behind Tier 5 cosmic endgame boss). Others (Chorus Drive, Null Engine) may be accessible earlier through cargo recovery.

### Voice, Eye, and Hand-Class

Lower-tier Resonance Web nodes. Voice-class transmits and amplifies. Eye-class perceives probabilities and unreal time. Hand-class manipulates matter, energy, or code. Distribution across cargo and planet-native is fully procgen. Named exemplar catalog is open.

---

## 19. Design Layers

The game is built on a deliberate split across three design layers.

- **Authored.** Constant across every playthrough. Mechanics, cosmology, lore framework, cultural archetypes, NPC role templates, item categories, boss archetypes, biome rules, the Halcyon crash premise.
- **Procgen.** Different every playthrough. World geography, specific NPC instances (including Arcadian crew), faction current state, cargo manifest specifics, item stats and naming, quest content, world history.
- **Emergent.** Simulated and story-told over time. Political dynamics (Turchin and Khaldun for factions), NPC memory and personal arcs, zone-creep into Normal Space, colony internal dynamics, narrative beats. RimWorld-school.

The **Character Ledger** is the connecting infrastructure: a structured, queryable record of who did what, who killed whom, who survived which event, who witnessed which Sundering, what Drift each character carries. Feeds both the Storyteller and NPC dialogue. Distinct from LLM context, which would hallucinate history. The Ledger is authoritative.

---

## 20. Reference Comparables

Confirmed inspirations and reference points, grouped by what they contribute.

**Survival and Building**
- Vintage Story: voxel-with-structural-rules, Heavy survival pressures, environmental physics.
- Minecraft: voxel baseline.
- Terraria, Core Keeper, Necesse: 2D survival pacing lessons.
- ARK, Conan Exiles, Last Oasis, ATLAS: tribe-based persistent survival.
- Subnautica: cosmological horror through curiosity.
- Don't Starve: tonal precedent for cosmological dread plus survival.

**Colony Simulation**
- RimWorld: AI Storyteller, prisoner and slave systems, faction relations baseline, Roster management. Heaviest single inspiration.
- Vanilla Factions Expanded (modded RimWorld): faction archetype variety, raid pacing.
- Dynamic Factions (modded RimWorld): the political simulation primitive we directly adapted (Stability, Influence, Leader Legitimacy, Attack, Defense, Entropy).
- Vanilla Ideology Expanded (modded RimWorld): meme-driven cultural variance.
- Hospitality (modded RimWorld): canonical pattern for our Path-b Relationship recruitment.
- Songs of Syx, Dwarf Fortress: deep colony political simulation precedents.
- Stranded: Alien Dawn: colony survival with named-survivor texture.

**Persistent World and Politics**
- Kenshi: political fluidity, persistent character vulnerability.
- Crusader Kings 3: nested political simulation, succession crises.
- Total War, Civilization: roll-up faction state design.

**Combat**
- Mordhau, Chivalry, Kingdom Come Deliverance: directional melee.
- Magicka, Witcher: skill-expressive casting models.

**Companion and Party**
- BG3, Mass Effect, Dragon Age: Companion management, multi-resolution choices.

**Knowledge and Discovery**
- Outer Wilds: knowledge-web discovery; clues are the progression.

**Industrial Scale and Crafting**
- My Time at Portia, My Time at Sandrock: structured Crafting Tier progression.
- Space Engineers: voxel-machine component logic.
- Palworld: integrated colony / combat / capture loop.
- Valheim: biome-gated tier progression with strong build emphasis.
- Dune Awakening: persistent voxel multiplayer survival baseline.

---

## 21. Open Questions

Tracked sub-questions still requiring resolution. Most are content questions (what specific items, NPCs, locations) rather than system questions (how things work).

### Cosmology and Endgame

- Voice / Eye / Hand-Class Artifact full named catalog.
- Which lost-ship's fate matters for endgame Solve content, and how.
- Endgame precondition exact thresholds (what counts as "high cumulative Null Drift," "balanced Drift profile," etc.).
- Endgame reversibility specifics (can a player back out of the Endgame Phase entirely, not just switch endings).

### NPCs and Roster

- Roster growth beyond recruitment: births? defection mid-game? integration of children? Are there generational mechanics?
- Void-Touched encounter mechanic: how a Sundered encounter actually plays out for the player (dialogue, combat, recruitment).

### Bosses

- Full archetype catalog across the five tiers.
- Per-archetype Resolution Path details: which paths exist, what conditions enable them.
- Boss-Defeat Enhancement specifics per boss.

### Storyteller

- In-fiction framing: is the Storyteller a named character, an unnamed beat-engine, an attributed force (the Broadcast itself, the Veiled Sleeper, an unknown observer)?
- Difficulty profiles: how many, what they vary, opt-in or opt-out per profile.

### UI and UX

- Dialogue UI system design.
- Faction Codex UI layout and visualization.
- Drift band visualization on the HUD.
- Crafting UI vs Tinkering UI distinction.
- Multiplayer party-selection UI.

### Opening Sequence Polish

- Tutorial-layer specifics for Act 1: exactly which mechanics taught, in what order, integrated with which officer.
- Crash sequence cinematic length and player agency during it.

### Tuning

- Drift accumulation specific numbers per action category.
- Endure Pressure tuning at Heavy difficulty: exact decay rates, exposure thresholds.
- Faction State Vector tick magnitudes per action.

---

## 22. Appendix A: Decision Log

Full record of decisions reached through grilling, in order. Each is a numbered lock referenced throughout this document.

1. Game spine is Endure. Other modes (Integrate, Solve, Sandbox, Escape) orbit.
2. Player is character-scale; colony is a sim layer beneath.
3. Colony stays home with party-formation overlay; max party 3-4, BioWare-style.
4. NPCs are tools AND quest-givers.
5. Design split: mechanics and archetypes authored, world and NPC instances procgen, narrative emergent.
6. Emergent storytelling layer modeled on RimWorld's AI Storyteller.
7. Default stakes are Soft Permanence with a Drift tick on respawn; Hardcore Mode is opt-in.
8. Cosmology is B + D + C: Broadcast (substrate, locally aware) plus Silence (anti-reality) plus Interference (the clash). Retooled from the Broadcast project, transposed from cyberpunk to Tesla-punk. Single-meter Void Corruption replaced by two-track Resonance Drift / Null Drift.
9. Zones manifest in three layers: Geographic (stable places), Weather (moving storms), Perceptual (visible only through Tesla, ritual, or Drift).
10. Drift is two independent meters (Resonance and Null, each 0 to 100). No offsetting. Decay via time and targeted-decay actions only.
11. Drift accumulation is nonlinear (1x/2x/4x/8x by 30-point band), per-action with continuous fallback for ambient sources, with discrete Drift Spikes for narrative events.
12. Drift decay is linear in time (1 point per game-hour baseline), modified by location and accelerated by activities.
13. Drift functions as a gating mechanism. Tesla and ritual gear are powerful but rationed; Conventional Gear remains relevant the entire game.
14. Drift-Gated Abilities are active-while-at-threshold, not permanent unlocks. Five bands per meter.
15. Combat is pure real-time action, multiplayer-first, with no tactical pause. Melee is Directional (Mordhau / Chivalry / KCD lineage). Drift-Powered casting is similarly skill-expressive.
16. Companion combat AI is baseline-plus-customization, with a real-time Command Wheel for orders.
17. Drift-Powered Casting uses a tuning mini-game as the primary mechanic, with Channel-and-Aim and Prime-and-Detonate as specialized modes.
18. Bosses are tiered across five levels. ~12-15 authored archetype templates, procgen-instantiated.
19. Each defeated boss permanently changes regional world state. Multiple Resolution Paths per boss.
20. Companion customization is hybrid: stance presets, equipment-driven adaptation, use-based skill growth, mentor-based specialization. Gambits excluded.
21. No character levels, no world scaling. Four parallel progression vectors.
22. Boss-Defeat Enhancements are chooseable: one of several rewards per boss.
23. Tesla scarcity uses a two-tier component model: manufacturable parts plus irreplaceable Resonance Cores. Five-tier Core Acquisition Pathway.
24. Optional off-by-default Manufacturing Mode toggle for late-game Core manufacturing.
25. Building uses voxel-with-structural-rules (Vintage Story school).
26. Environmental Physics overlays the voxel world. Drives survival pressures and ambient Drift accumulation.
27. Default Endure Pressures are Heavy (Vintage Story school). Player-tunable to Medium or Light.
28. Opening Sequence is three-act with no time-skip.
29. Role Continuity: NPC-led arcs attach to roles, not specific procgen instances. No specific Companion-instance is a soft-lock dependency.
30. Multiplayer Shared / Personal Split: structural arc progress and knowledge are colony-shared; Companion relationships are per-player.
31. Recruitment of locals has five mutually non-exclusive Pathways (Quest, Relationship, Opportunity, Faction-Standing, Coercion).
32. Faction Simulation uses a six-parameter State Vector per faction, ticked by the Storyteller. Adapted from Dynamic Factions with Turchin / Khaldun framing.
33. Coercion mechanics adapt RimWorld prisoner / slavery systems. Two parallel stats (Resolve, Will), Suppression maintenance, rebellion math, Unwaveringly Loyal class, Conversion redemption.
34. Faction model is Macro + Sub-Faction. Four Macro Factions, ~20-30 Sub-Factions total.
35. Faction Visibility is earned per Sub-Faction per parameter. Four granularities (Hidden, Vague, Approximate, Precise). Six Information Sources.
36. Player Faction Influence operates through six action categories. Effect model is Hybrid.
37. Geographic representation is Layered: voxel world plus procgen Settlement Points plus radial Influence Zones. Crash Site Placement is procgen-bounded.
38. Faction State Vector Tick Rate is Multi-rate Hybrid.
39. Strain Event participation is Tiered by proximity and Integration.
40. Sub-Factions follow a full Faction Lifecycle. Birth, death, caps, Ruins.
41. All seven Heart-Class artifacts canonically present every playthrough using original Broadcast doc names. Procgen splits them between cargo and planet-native. Some tier-locked. Cargo Manifest total is procgen.
42. Endgame Shape is Hybrid: five distinct endings gated by player history. Three game-ending cinematics (Merge, Restoration, Annihilation). Two transformed-sandbox (Ascension, Steward).
43. Endgame transition uses Hybrid Phase + Activation. Endgame Phase is 1-3 game-weeks. Each ending has its own activation mechanic.
44. Endgame multiplayer resolution uses in-fiction faction politics. Halcyon Internal Sub-Factions back specific endings.

---

*End of design document. Companion artifact: CONTEXT.md (live glossary of canonical terms).*

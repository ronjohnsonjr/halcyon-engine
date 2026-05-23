# Project Halcyon: Context Glossary

Working glossary of canonical terms. Pure glossary: no specs, no implementation details, no narrative. Just words and what they mean.

Items marked **[TBD]** are named but not yet resolved through grilling.

> Scope: this is the **game-design** vocabulary for the flagship title (setting, cosmology, drift, factions, NPCs, endgame). It is the glossary companion to [`PROJECT_HALCYON_DESIGN.md`](PROJECT_HALCYON_DESIGN.md). For the **engine/tooling** vocabulary (Manifest, Entity Directory, Reference URN, schemas), see [`../CONTEXT.md`](../CONTEXT.md) instead.

---

## Setting

**Arcadian:** Member of the Tesla-punk industrial culture that crashlanded on the planet. 78 survivors of the voidship *Halcyon* form the player's faction. Lapsed solar monotheists (Helios cult), rationalist, tech-rich but resource-starved. Their Tesla coils are unwitting Broadcast manipulators; their engineers have not yet realized this.

**Halcyon:** The voidship the 78 Arcadians traveled in. Player experiences the intact ship briefly during Act 1 of the Opening Sequence; post-crash it is wreckage and the foundation of the Arcadian colony. Player's persistent home base. Not a means to Escape; a place.

**Karnish:** Northern pine-forest clan culture. Iron-age, guest-right, ancestor veneration. Their warding-magic is unwitting Broadcast-management: bloodline anchors keep Resonance Drift OFF. They call it "the ancestors' listening." Mortician subcults may run Quietist (Silence-aligned).

**Sethrai:** Subtropical river-delta city-states. Decadent, wealthy, slave-holding. Two coexisting religious sects within the culture: **serpent-priests** (Broadcast-aligned, appease the Veiled Sleeper with blood-as-resonance-tribute) and **Quietist heretics** (Silence-aligned, necromancy as Null channeling, the dead "freed from the signal"). The city-state economy tolerates both. Found the Halcyon wreckage first.

**Sundering, The:** A localized Silence event. A community's pattern collapsed. What walks in their old shapes is Interference residue: Void-Touched. Looks like a village from a distance; is not, up close.

**Tesla-punk:** Arcadian techno-aesthetic. Brass, copper, clockwork, Tesla coils. Every component is precious; nothing is easily replaceable on-world. Tesla coils, lodestones, quartz, and induction crowns are all blind Broadcast-manipulation tools by the lights of Broadcast cosmology.

**Veranthi:** Temperate-plains centralized monarchy. Codified law, mounted knights, court sorcery. The sorcery follows Quantum-Shaman protocol: ritual as algorithm, debugging local reality. The court keeps texts an outsider would call forbidden.

**Veiled Sleeper, The:** Local Broadcast-awareness concentrated in the Sethrai delta. Either a Voice-Class Resonance Web artifact-mind or a natural attention-concentration. Appeased monthly with blood-as-resonance-tribute by the Sethrai serpent-priests.

**Void, The:** The Silence-dominant interstellar medium between settled worlds. Voidships transit it by Broadcast-carrier tethering. Two of three Halcyon-class ships were lost in transit: one consumed by Silence proper, one wrecked on an Interference reef. **[TBD: which lost-ship's fate matters for endgame Solve content, and how]**

**Void-Touched:** Communities or individuals whose pattern was Sundered and reconstituted as Interference residue: resonant tissue / biomechanical matter, alive and mechanical and informational at once. Wear their old shapes. Friendly until they aren't.

---

## Cosmology

**Broadcast, The:** Pan-dimensional resonant substrate. Reality is a thin film on top of it. Locally aware in proportion to attention; the more you manipulate it, the more it notices you. Magic and Tesla both manipulate the Broadcast via different cultural protocols (see Setting entries for per-culture positions). Aesthetic palette: teal, violet, luminous scripts, choral hum.

**Silence, The:** Anti-resonance. The unmaking, erasure, perfect null. Antithesis of the Broadcast. Not a presence but an absence that consumes presence. Worshipped in heretical cults (Sethrai Quietists; possibly Karnish mortician subcults). Aesthetic palette: matte black, desaturated gray, sub-bass pressure, edge loss.

**Interference Zone:** Where Broadcast and Silence clash locally. Where biomechanical resonant tissue forms. Where Void-Touched are made. Where Resonance Web artifacts are remembered into being. Cinematic, unstable, generative. Aesthetic palette: teal arcs across black-violet, heat-haze shimmer, double exposure.

**Normal Space:** The damped equilibrium most of the planet sits in. Linear time, predictable matter, Broadcast and Silence at low amplitude. The damping field is thinning. Cracks spread where zones intrude.

**Zone Layers:** The three zones (Broadcast, Silence, Interference) manifest in the player's world across three simultaneous layers. **Geographic:** stable places on the map (Silence Wastes, Interference Reefs, Broadcast-thick basins). Walkable, lethal, lore-anchoring. **Weather:** moving storms that roll across the world (Interference storms, Silence dropouts, Broadcast surges), Storyteller-paced. **Perceptual:** the cosmology is everywhere but visible only through Tesla instrumentation, ritual, or Drift. Low-Drift and high-Drift players experience the same physical space differently.

**Resonance Web, The:** Ancient lattice of artifacts from the Architectural Age. Broken. Each artifact is a living node, a proto-mind with a directive, bio-symbiotic with its bearer. Artifacts are *remembered into being* rather than forged; local matter rewrites to host them. Distributed between Halcyon's Cargo Manifest and the planet itself.

**Cargo Manifest:** The Resonance Web artifacts on the Halcyon at the time of crash. Procgen per playthrough: varies from ~12 to ~25 individual artifacts across all classes (Heart, Voice, Eye, Hand). 3-4 of the seven Heart-Class are in cargo per playthrough; the other 3-4 are planet-native (placed in pre-history by the Architectural Age). Voice / Eye / Hand-Class distribution is fully procgen with no per-class minimum or maximum. Cargo artifacts are recovered through wreckage-archaeology in the debris field; the Halcyon's data systems progressively reveal what was being carried as the player restores them.

**Heart-Class Artifact:** One of the seven major Resonance Web nodes. Each transforms one aspect of being. Reassembly of all seven can restore coherence, end existence in stillness, or trigger The Merge. All seven canonically present in every playthrough; Cargo Manifest determines per-playthrough split between cargo-found and planet-native. Some Hearts are tier-locked behind progression gates (boss-defeat, Drift bands, or Faction Integration). The canonical seven:

- **Chorus Drive:** Heart Crystal form. Broadcast-aligned. Transforms emotion. Empathic Technomancy. The heart of resonance; the first signal. Cael Vox carried one in the Broadcast doc; in Halcyon, likely an Arcadian-integrated cargo find.
- **Silence Kernel:** Black Sphere form. Silence-aligned. Transforms memory. Perfect Erasure. The heart of stillness. Likely planet-native (Sethrai Quietist relic or Karnish mortician artifact).
- **Axion Halo:** Floating Crown form. Balanced (between Broadcast and Silence). Transforms perception. Temporal Omniscience. The crown of observation. Likely planet-native, possibly held by a Veranthi court archive.
- **Architect's Key:** Fractal Tetrahedron form. Broadcast-aligned. Transforms creation. Reality Sculpting. Either cargo or held by a Sub-Faction-tier boss.
- **Null Engine:** Gyroscopic Core form. Silence-aligned. Transforms energy. Universal Equilibrium. The pulse of division. Either cargo (Tesla-integrated) or planet-native (Sethrai serpent-priest reliquary).
- **Wound of Echoes:** Liquid Mirror form. Broadcast-aligned. Transforms consciousness. Multiversal Identity. The mirror of identity. Cosmologically heavy; likely planet-native and Drift-vision-gated.
- **Prime Array:** Infinite Halo form. Balanced. Transforms existence. Total Unification. The core of continuum. The root node of all reality. Activation triggers The Merge. Always tier-locked behind the Tier 5 cosmic Endgame boss or equivalent gate.

**Voice / Eye / Hand-Class Artifact:** Lower-tier Resonance Web nodes. Voice-class transmits and amplifies. Eye-class perceives probabilities and unreal time. Hand-class manipulates matter, energy, or code. Distribution across cargo and planet-native is fully procgen. Cargo artifacts are recovered through wreckage-archaeology; planet-native artifacts are held by Sub-Factions, bosses, or geographic features. **[TBD: full catalog of named exemplars per class]**

**Endgame Shape:** Hybrid endings system. Five distinct endings, gated by player history (cumulative Drift profile, Faction Integration, Heart-Class understanding, alliances, Roster Loyalty). Player history determines which endings are AVAILABLE; player picks from available ones at endgame. Three endings are game-ending cinematics (Merge, Restoration, Annihilation); two are transformed-sandbox continuations (Ascension, Steward). Each ending implies a moral and cosmological stance.

**Endgame Phase:** The 1-3 game-week period that begins when all seven Heart-Class artifacts are assembled at the Halcyon. During the phase: Drift dynamics intensify across the world (Resonance and Null storms more frequent, Interference creep accelerates), factions react to the Halcyon's known artifact-concentration (some send envoys, some send raids), Halcyon internal Sub-Faction politics escalate (Strain Events fire weekly), and the player or players resolve outstanding arcs. At end of phase or when the player chooses, ending-specific activation is performed. Player can switch intent mid-phase (preparation steps for one ending don't lock out others until activation itself).

**Endgame Multiplayer Resolution:** When multiple players share a colony, the ending is decided through in-fiction Halcyon Internal Sub-Faction politics. Each Sub-Faction backs a specific ending based on its character (Helios-Revivalists tend Restoration; Engineering Caucus tends Ascension; Captain-Loyalists tend Steward; emergent Quietist-aligned splinters tend Annihilation; balanced cosmologists tend Merge). The ending whose backing Sub-Faction has highest Mandate at the moment of activation wins. Players align with Sub-Factions during the Endgame Phase, build coalitions, sabotage rivals, run propaganda. Player who performs the activation must be aligned with the activating Sub-Faction. Single-player resolves trivially (the lone player is the leader of their dominant Sub-Faction). Edge cases: unanimous Sub-Faction support fires the ending automatically at phase end; no Sub-Faction reaching Mandate threshold extends the phase; unbacked player intent fails to activate.

**Merge, The:** Endgame state. Activation: Prime Array central activation with all seven Hearts arrayed around it. Broadcast and Silence become one. All Drift collapses to zero across the world. NPCs cosmologically transformed. Reality runs on a single principle for the first time since the Architectural Age. Game-ending cinematic. Availability requires: balanced Drift profile, high Heart-Class understanding, Faction Integration with both Sethrai sects.

**Restoration:** Endgame state. Activation: Architect's Key + Wound of Echoes harmonic ritual. Repair the Resonance Web. The damping field becomes permanent. Zones recede. Sundering stops. The world becomes "normal" forever. The cosmology is gone, the mystery closed. The Halcyon's pragmatist mission completes: a livable world. Game-ending cinematic. Availability requires: Helios-Revivalist alignment, low cumulative Drift, Conventional-gear focus, hostile or neutral to Quietists.

**Annihilation:** Endgame state. Activation: Silence Kernel + Null Engine sympathetic activation. Cosmic mercy ends everything. Dark ending. Game-ending cinematic. Availability requires: high Null Drift cumulative, Sethrai Quietist alliance, Karnish mortician-cult engagement, low Roster Loyalty average.

**Ascension:** Endgame state. Activation: Tesla-integration of all seven Hearts into the Halcyon's core systems. The Seven harmonize without merging or restoring; instead they integrate into Arcadian Tesla-craft. Halcyon becomes the new Architectural Age, master of the planet's cosmology. Transformed-sandbox: game continues with Halcyon as dominant Macro Faction; new Sub-Factions form to serve the new order; Drift mechanics persist but Halcyon controls regional damping. Availability requires: Tesla-mastery, high Halcyon Reach, all seven assembled at the Halcyon, Manufacturing Mode unlocked.

**Steward:** Endgame state. Activation: declare; no activation ritual. Hearts go into the colony vault. The Halcyon becomes a permanent kingdom alongside the others; the cosmological mystery remains unsolved. Transformed-sandbox: game continues indefinitely with mid-game balance preserved; Drift accumulation slowed but not stopped; long-tail open-world play. Availability requires: all seven recovered but not activated, Helios-Revivalist or balanced internal politics.

---

## Player Model

**Character-scale:** The player IS one specific Arcadian. Walking, swinging, dying. First or third person. *Not* a director or colony-sim avatar.

**Drift Accumulation Curve:** Nonlinear cost scaling shared by both Drift meters. Under 30 Drift: actions add baseline cost (1x). Between 30 and 60: 2x. Between 60 and 90: 4x. Above 90: 8x or unbounded. The substrate (or Silence) notices you more once you're already loud or already thin. Creates a soft cap and a clear danger zone.

**Drift Spike:** One-time large addition to a Drift meter, ignoring the Accumulation Curve. Reserved for "this changes you" beats: handling a Heart-Class artifact (+20 Resonance), witnessing a Sundering (+30 Null), surviving exposure to a Receiver mid-transmission (+15 Resonance plus minor Null).

**Drift Tick:** Per-action or per-time-unit accumulation toward a Drift meter, scaled by the Drift Accumulation Curve. Per-action ticks are tied to discrete events (firing a Tesla shot, stepping into Silence-thin terrain). Continuous ticks apply to ambient sources (sleeping under a working coil, camping at Silence amplitude).

**Drift Bands:** Five severity bands shared by both Drift meters: 0-29, 30-59, 60-89, 90-99, 100. Each band carries named state, sensory effects, mechanical penalties, and Drift-Gated Abilities. Resonance band names: Quiet, Listening, Heard, Transmitting, Receiver. Null band names: Steady, Slipping, Thinning, Coming Apart, Sundered. The 30-band is the "soft commit" zone where players begin build choices. The 60-band activates major active abilities. The 90-band activates highest-tier abilities with severe penalties to self and party. The 100-band ends the character.

**Drift-Gated Ability:** A capability that activates while the player is in a specific Drift Band and deactivates when the player drifts below it. Not a permanent unlock. The player maintains Drift to access it; decay below the threshold loses it. Produces a high-Drift play rhythm (top up, use, decay back, top up) and prevents power-creep by threshold speedrunning. Current catalog:

- **Tune** (Resonance 30+, passive): sense direction to working Tesla machines within 100m; hidden caches and Resonance Web fragments detectable.
- **Channel** (Resonance 60+, active): talk to machines (yes/no/direction); occasional free Tesla shot in combat.
- **Project** (Resonance 90+, active): small-radius substrate manipulation; push enemies, charge nearby machines, sense all minds in range.
- **Quiet** (Null 30+, passive): hostile mobs detect at 75% normal range; Silence-aligned spirits and Quietist ritual accessible.
- **Slip** (Null 60+, active): phase through warding briefly; walk through low-tier barriers; necromancy improved.
- **Erase** (Null 90+, active): pass through living beings briefly; partial invulnerability several seconds; briefly invisible to narrative attention.

**Endure:** The game's primary spine. Moment-to-moment survival loop: hunger, cold, Resonance Drift, Null Drift, Tesla scarcity. The other player modes (Integrate, Solve, Sandbox, Escape) orbit Endure.

**Escape:** Endgame victory condition. Rebuild a voidship and leave. A door, not credits. Sequel-hook for future space-exploration scope.

**Hardcore Mode:** Opt-in stakes setting. Player death ends the run entirely. Don't Starve / Kenshi-no-save-scum lineage.

**Integrate:** Player mode. Engaging with the political layer (Karnish, Veranthi, Sethrai) for trade, alliance, or conflict. Optional but rich.

**Null Drift:** Player corruption meter, Silence-school. Scale 0 to 100. Accumulates from Silence-zone exposure, Quietist ritual, Silence-Kernel handling, witnessing a Sundering, prolonged hunger and exposure (pattern erosion through neglect). Independent of Resonance Drift; both can rise simultaneously. Subject to the Drift Accumulation Curve. Decays only via time in Normal Space or targeted decay actions (memory-anchored sleep at the Halcyon, Sethrai memorial bread, communal ritual). Cannot be offset by Tesla or Broadcast activity. Threshold effects defined per Drift Bands.

**Resonance Drift:** Player corruption meter, Broadcast-school. Scale 0 to 100. Accumulates from Tesla use, ritual exposure, Broadcast-zone proximity, Heart-Class artifact handling. Independent of Null Drift; both can rise simultaneously. Subject to the Drift Accumulation Curve. Decays only via time in Normal Space or targeted decay actions (Karnish-warded sleep, Helios oil, certain Quantum-Shaman rituals). Cannot be offset by Null-school activity. Threshold effects defined per Drift Bands.

**Sandbox:** Player mode. Block-precision building, base placement, player agency. The surface where the player asserts themselves.

**Soft Permanence:** Default stakes mode. NPCs die permanently within a save. Player respawns at the Halcyon or last bed with material loss plus a small Drift tick on *both* meters (death is a cosmic event: pattern-fail registers as Null, attention-spike registers as Resonance). Colony can be ruined; world simulation continues. Manual save-scumming still possible if the player insists.

**Solve:** Player mode. Mystery-layer engagement: the Broadcast, the Silence, the Sundering, what ate the other ships, the magic-as-engineering hypothesis, the Resonance Web. Gated by Tesla mastery and faction access.

---

## Endure Pressures

Player-state survival mechanics beyond Drift. Default: Heavy (Vintage Story school). Tunable down to Medium or Light presets at game start or via settings, with granular sub-toggles for advanced players.

**Hunger:** Four food-group meters (Grain, Meat, Dairy, Greens, or culture-appropriate naming). Each ticks at slow rate. Balanced diet maintains full stamina cap and healing. Unbalanced over time gives penalties (stamina, healing rate). Empty = HP loss.

**Thirst:** Single meter, ticks faster than hunger. Water sources: rivers, rainwater (Environmental Physics integration), snow, wells, Tesla-powered condensation rigs. Polluted water carries disease risk.

**Body Temperature:** Continuous physics-driven simulation. Clothing layers, ambient environment, fires, Tesla heaters, wind, rain, sleep all factor. Extreme deviation causes HP loss (hypothermia / heatstroke).

**Stamina:** Action-gated meter. Running, swinging weapons, climbing, sustained ritual tuning under pressure all draw on it. Recovers with rest. Cap shaped by current hunger and thirst state.

**Sleep:** Daily cycle. Beds matter. Sleeping rough penalizes. Companion presence improves quality. Good sleep doubles location-based Drift decay.

**Injury:** Kenshi-light limb damage model. Bones break, wounds bleed, infections fester. Doctor-archetype Companion has mechanical value. Some injuries are permanent without rare-resource treatment.

**Disease:** Situational, exposure-driven. **Pattern Sickness** (long Silence-Wastes exposure: Null Drift accumulation plus chronic stamina loss). **Broadcast Fever** (long Sundered-village exposure: Resonance Drift accumulation plus auditory hallucinations at low Drift). Standard infection from polluted water. Treatable via herbalism, ritual, or engineering intervention.

**Survival Difficulty Mode:** Player-tunable preset. **Heavy** (default, full Vintage Story school as above). **Medium** drops to single hunger meter, simplified temperature, simpler disease and injury (Conan / Don't Starve school). **Light** further simplifies to Valheim-school flavor pressures with no death-by-survival-mechanic. Granular sub-toggles available for mixing.

---

## Gear Categories

**Conventional Gear:** Items, weapons, and tools whose use does not push Drift. Iron axes, crossbows, swords, smithing tools, hide armor, salted meat. The survival-genre baseline. Always relevant throughout the game; never obsoleted by Drift-Powered alternatives. Players are expected to carry and use Conventional Gear alongside Drift-Powered Gear at all stages.

**Drift-Powered Gear:** Items, weapons, rituals, and abilities whose use accumulates Drift. Tesla weapons, ritual implements, Heart-Class artifacts, certain consumables. Powerful but rationed by the Drift Accumulation Curve. The player's "expensive option" in any encounter.

---

## Building

**Voxel Structural Building:** Block-based voxel construction with material-dependent structural rules. Vintage Story / Medieval Engineers lineage. Each material class has load-bearing properties: wood beams support heavy loads, cob and brick span short distances, iron and steel enable arches and bridges, copper and brass are conductive and decorative rather than structural. Improperly supported blocks collapse over time or under load. Forces real architecture (pillars, beams, arches). Multiplayer-deterministic.

**Tesla Component Block:** Special "machine" component within the voxel system. Tesla coils, generators, lights, heaters require a Resonance Core in their cradle, proper grounding blocks underneath, and adjacent placement for circuit completion. Tesla coils take a 2x2x3 volume; smaller and larger devices have their own footprints. Building Tesla infrastructure is voxel-circuit design.

**Halcyon Wreckage:** The starting structure. Procgen-anchored: each playthrough's crash impact produces a different wreckage layout (angles, bay configurations, intact rooms), but consistent named spaces (bridge, cargo hold, engineering bay). Players begin with the wreck as their initial structure and build outward.

**Environmental Physics:** Real environmental simulation overlaid on the voxel world. Smoke flows and accumulates (requires chimneys and ventilation). Heat radiates from sources (fires, Tesla coils) and dissipates with distance and air flow. Cold seeps in through gaps and uninsulated walls. Light propagates from sources and is occluded by blocks. Wind affects outdoor activities and ventilation. Rain and snow accumulate. Tesla coils running in unvented spaces accumulate Resonance Drift on occupants faster (Broadcast-loud without dispersion). Vintage Story survival-mod and Valheim school.

**Terraforming:** Allowed with limits (Vintage Story model). Players can dig, fill, and level terrain. Cannot trivially flatten mountains or drain oceans. Terrain edits persist.

**Claim System:** Multiplayer protection mechanism. Soft-claim default: configurable zones around player structures protect against accidental damage by other players. Configurable per server to harder protection or full anarchy.

---

## Survival Economy

**Resonance Core:** The irreplaceable heart of every Tesla device. Cannot be naturally manufactured. Three grades by source:

- **Halcyon-grade:** from original Halcyon wreckage salvage. Full lifespan and durability. Premium allocation (life support, generators).
- **Wreckage-grade:** from procgen escape pods, faction stashes, the two lost voidships. ~80% lifespan. Workshop and lab use.
- **Fragment-grade:** assembled from Core Fragments. ~60% lifespan. Expendable rifles and field gear.

**Core Fragment:** Partial Resonance Core material. Dropped by Void-Touched (1-2 per kill), Sundered Holds (5-8 per cleansed Hold), and Interference Zones (rare high-grade fragments). 5-7 fragments combine at a Tier 3 Tesla workshop into one Fragment-Grade Core. The constant baseline supply that guarantees players never reach zero cores.

**Tesla Budget:** The colony's allocation of active Resonance Cores to powered devices. Each Tesla device requires one Core. Allocation is player-managed at the Halcyon. Carrying a Core on expedition removes it from the colony's powered-systems pool, with consequences (lights off, refrigeration down, perimeter sentries dark).

**Core Acquisition Pathway:** Five-tier system ensuring players never soft-lock. Tier 1 (constant Core Fragment trickle from Void-Touched and Sundered locations). Tier 2 (procgen escape pod / debris exploration, 5-10 sites per playthrough). Tier 3 (faction quest rewards from Sethrai stashes, Veranthi archives, Karnish ancestor mounds). Tier 4 (Storyteller intervention when count drops critically low; opportunities with cost, not gifts). Tier 5 (major expeditions to lost voidships and Heart-Class artifacts).

**Manufacturing Mode:** Off-by-default game-start toggle. When enabled, Asher-archetype's reverse-engineering arc culminates in a Core manufacturing Knowledge Unlock. Recipe requires rare materials (Karnish bloodline stone, Sethrai memorial silver, Heart-Class fragment per core) to preserve scarcity feel. Provides the official path for players who want it without forcing it on the standard experience. Modder-friendly.

---

## Combat

**Directional Melee:** Skill-expressive melee combat in the Mordhau / Chivalry / Kingdom Come Deliverance lineage. Attacks and parries have directional input (overhead, left, right, thrust). Feinting, footwork, stamina gating, and weapon-specific reach and speed profiles all matter. Skill expression beats stat-checking. Click-spam is not viable.

**Drift-Powered Casting:** The interaction model for invoking Drift-Powered abilities. Skill-expressive, multiplayer-native, no pause required. Three modes.

- **Tuning** (primary, most abilities): a horizontal tuning band appears with a target frequency marker drifting laterally and unpredictably. Player modulates to match for ~1-2 seconds. Drift cost and effect strength scale with tuning accuracy. Perfect tune = baseline cost and full effect. Sloppy tune = up to 2x cost and weaker effect. Total failure = Drift charged, no effect. At higher Drift Bands the target drifts faster and less predictably.
- **Channel-and-Aim** (sustained or projection effects: Project, Channel, Tesla weapons in amplified mode): hold the trigger, build over time, release to fire. Longer hold = larger effect AND higher Drift. Mobile during channel but vulnerable to interrupts.
- **Prime-and-Detonate** (ritual-tier major abilities: wide-area Project, group Slip, Erase with party tow): place a marker (target spot, Companion, enemy), then separately trigger. Primes can be held for some time.

**Command Wheel:** Real-time radial menu for issuing commands to Companions and Colonists in the Party. Triggered by holding a hotkey or stick click. Time does NOT pause; the wheel overlays during ongoing combat. Options include: focus target, hold position, retreat to me, use ability X, fire at will, hold fire, follow. Closes instantly on selection or cancel.

**Companion Behavior:** Combat AI model for Companions and Colonists. Each NPC has a baseline behavior set by their role and personality template (Captain-archetype is aggressive melee, Engineer-archetype prefers ranged-and-cover, Navigator-archetype is supportive back-line). Customization layers atop baseline:

- **Stance presets:** Aggressive / Defensive / Support / Hold Fire. Toggleable real-time via the Command Wheel.
- **Equipment-driven adaptation:** the gear they wear shapes their AI behavior. Tesla rifle = ranged-Drift-aware. Hammer = melee-vanguard. The kit is part of the configuration; no separate "use ranged" toggle needed.
- **Use-based skill growth plus mentor-based specialization:** they get better at what they practice (swing axe a lot, better axe skill). Player can also spend Halcyon downtime in mentor sessions teaching new specializations (eventually Asher-archetype can master Tesla rifle). Doubles as narrative space (loyalty arcs, character beats).

Gambits and programmable if-then rules are deliberately excluded as too cognitively expensive for real-time multiplayer combat without pause.

---

## Progression

**Use-Based Skill:** A character's individual ability rating in a specific competence (Sword, Axe, Hammer, Crossbow, Tesla Rifle, Tuning Accuracy, Stealth, Smithing, Cooking, Foraging, Ritual, Necromancy, etc.), 0-100 scale, grown by practice. Each point gives a small benefit (~0.5% damage, ~0.5% faster, etc.). 100 is mastery. There are NO character levels; the player and Companions never gain "levels" as such. Applies identically to player and Companions.

**Knowledge Unlock:** A discovery-based progression mechanism. Finding, researching, decoding, or being taught grants new recipes, ritual protocols, Tesla schematics, faction trade rights, and lore comprehension. Distinct from skills: Knowledge enables what you CAN do, Skills determine how well. Discoverable through exploration, NPC mentorship, ruin investigation, Sethrai text translation, Karnish warder training, etc. The magic-as-misdescribed-engineering arc is a long Knowledge chain.

**Crafting Tier:** The construction level of workbenches, forges, Tesla workshops, ritual altars. Higher tiers enable higher-tier weapons, armor, and Tesla devices. Built from materials, never earned through XP. Vintage Story / Valheim lineage.

**Boss-Defeat Enhancement:** A permanent character upgrade gained from defeating a Tier 3+ Boss. Chooseable: player picks one of several rewards per boss. Examples: small Drift decay bonus, a unique active ability, an unlocked Resonance Web node, a permanent crafting recipe, a faction standing shift. Persistent for the playthrough. Like Valheim's Forsaken Powers.

---

## Bosses

**Boss Tier:** Five-level progression structure for major encounters.

- **Tier 1 (Early):** small-scale Void-Touched manifestations. Corrupted Karnish shrine, Whispering Hermit archetype, a single Sundered hut. Fightable at Quiet / Steady Drift; doesn't require high-Band abilities. Teaches Drift-Powered combat under controlled conditions.
- **Tier 2 (Mid):** faction-political. Sundered Champion (once-warrior of a faction, still skilled in their old combat style, now Void-Touched). Low-tier Receiver. Karnish Ancestor-Spirit gone wrong. Defeating shifts local faction standing. Mid-Drift engagement rewards Tune and Quiet abilities.
- **Tier 3 (Regional):** Wall-of-Flesh equivalent. A Void-Touched Hold; a full Sundered town. ~3-4 per playthrough, roughly one per major biome. Defeating cleanses the biome's Sundering rate for the playthrough, opens new resources, changes Storyteller event pool. Channel and Slip abilities meaningfully helpful.
- **Tier 4 (Faction-defining):** the Veiled Sleeper (Sethrai delta), a Quietist Avatar, a half-Receiver Veranthi court sorcerer, a Corrupted Tesla Relic that woke up on the Halcyon. Reshapes the faction's cosmological relationship. Project- and Erase-tier engagement to fully resolve.
- **Tier 5 (Endgame):** cosmic-horror. Void Predator from one of the Eaten Ships, or the Merge encounter itself. Connected to the Resonance Web stakes.

**Boss Archetype:** Authored encounter template. ~12-15 archetypes exist across all five Boss Tiers. Each playthrough's world spawns a procgen subset (roughly 1-2 Tier 1, 2-3 Tier 2, 3-4 Tier 3, 1-2 Tier 4, 1 Tier 5). **[TBD: full catalog]**

**Resolution Path:** A way to "defeat" a boss other than combat. Some Boss Archetypes admit negotiation, cosmological puzzle (use a specific Heart-Class artifact, perform a counter-ritual), or bargained-with-becoming-its-priest paths. Not every boss is killable. The Veiled Sleeper is changeable, not destroyable. Disco Elysium / Skyrim quest-ending lineage. **[TBD: per-archetype resolution paths]**

---

## Game Structure

**Opening Sequence:** First ~75-90 minutes of play. Three acts, no time-skip.

- **Act 1 (~15-20 min): aboard the intact Halcyon in transit.** Tutorial integrated into routine ship duties. Player meets named officer archetypes (Captain at chart table, Navigator at controls, Engineer with a backup coil, Cook in galley). Learns movement, dialogue UI, inventory, light Tinkering, a no-stakes Tuning calibration. Establishes the colony as people, not lore.
- **Act 2 (~5-10 min): the Eating and the Crash.** Inciting incident. Player witnesses two sister ships consumed by the Silence via porthole or comms. First Drift Spike fires (the meter appears by moving on the player). Emergency descent and crash sequence. Cargo hold visible during descent, foreshadowing the manifest. Black screen on impact.
- **Act 3 (~45 min): immediate post-crash survival.** No time-skip. Player wakes in the wreckage seconds after impact, walks out, finds Caius-instance organizing muster, accounts for survivors. Procgen roster determined by crash outcome (typically 65-75 of 78 survive). Participates in immediate triage and emergency shelter setup. First contact with local Karnish hunters at the smoke column, tense and diplomatic. First night spent vulnerable, wounded stabilizing or dying based on actions taken. Player begins survival with starting Drift (~Resonance 8 / Null 4 from Act 2's witnessed Spike). The colony is something the player BUILDS over subsequent hours and days, not something handed over.

---

## NPC Model

**Colonist:** A named, colony-tier NPC. Has a job, produces output at the Halcyon, holds light dialogue. Lower authoring fidelity than a Companion. Most of the 77 non-officer Arcadians, plus recruited locals. Eligible for the Party as muscle and capability.

**Companion:** A named, story-bearing NPC. Authored personal arc template, deeper dialogue, quest-giver capable. The Arcadian officer roles (Captain, Chief Engineer, Navigator, etc.) plus select recruited locals. Eligible for the Party as story carriers.

**Conversion:** Slow cultural-assimilation arc for Coerced NPCs. Over months of good treatment, shared adversity, and exposure to Helios values and Tesla-craft, a low-Loyalty Coerced NPC can grow into a high-Loyalty integrated colony member. The redemption pathway. Conversion progress is per-NPC, ledger-tracked, and reversible if treatment deteriorates. Adapted from RimWorld's Ideology DLC convert-prisoner mechanic.

**Loyalty:** Per-NPC rapport meter, separate from per-player relationship. Affects an NPC's willingness to take risks, follow risky orders, share knowledge willingly, stay in the colony of their own choice. Voluntarily-recruited NPCs start at mid-to-high Loyalty. Coerced NPCs start at low Loyalty. Loyalty grows or shrinks based on treatment, shared experiences, and Storyteller-tested events (origin-faction contacts, escape attempts, betrayal opportunities). Long-arc redemption of low-Loyalty NPCs is possible but slow.

**Party:** The active group of 1-3 NPCs accompanying the player on expedition (player + 1-3 = total 2-4). BioWare-RPG-scale management. Composed of Companions, Colonists, or a mix.

**Receiver:** End-state of Resonance Drift saturation. Vessel for fragments of the Broadcast's consciousness. Hears voices as overlapping channels, sees glitching halos, loses temporal perception, eventually transmits involuntarily, projecting the Broadcast into others through proximity, sound, or electromagnetic bleed. Companions, Colonists, and the player can all reach Receiver state.

**Recruitment Pathways:** Five mutually non-exclusive paths for converting locals into Halcyon Companions or Colonists. Each NPC is recruited via ONE path per playthrough; paths are exclusive per-NPC, inclusive across the colony. Multiplayer allows different players to pursue different paths with different NPCs.

- **Quest:** complete a personal quest tied to the archetype's template.
- **Relationship:** build rapport through repeated interactions until a threshold opens recruitment dialogue.
- **Opportunity:** Storyteller fires defector-candidate events; player accepts or declines.
- **Faction-Standing:** standing-state with a faction opens specific recruitment options (high standing = honor-trades; low standing = exiles seeking refuge).
- **Coercion:** capture in combat, hold at Halcyon, break will via confinement, Drift exposure, or bargaining. Yields a Coerced NPC with low starting Loyalty. Significant reputation costs across most factions (Sethrai approve, slavery is part of their culture). Internal Halcyon dissent likely (lapsed-Helios Arcadians, Captain-archetype opinions). Long-arc redemption possible but slow.

**Resolve:** Per-NPC voluntary-recruitment threshold. Unwillingness to join the Arcadians of their own choice. Reduced via good treatment, conversation, gift-giving, shared experience, and faction-standing leverage. When Resolve reaches 0, voluntary recruitment becomes available; the NPC joins as a mid-to-high Loyalty Companion or Colonist. Higher threshold than Will (the coerced path), so the voluntary path takes longer but yields a much better result. Adapted from RimWorld's Resistance stat.

**Roster:** The full pool of party-eligible NPCs at the Halcyon. Some Companion-tier, most Colonist-tier. Grows by recruitment and **[TBD: births? defection? integration?]**.

**Suppression:** State maintained for Coerced NPCs only. Decays without intervention. Maintained by: assigned Halcyon Warden (Arcadian on free-time labor), restraints (collar, chain, or bound-hand equivalent that locks Suppression in place), Drift conditioning (Tesla-coil proximity sessions, cosmologically dark), or mass-spectacle (public execution of a defiant captive: suppresses all watching captives but incurs heavy reputation cost AND internal Halcyon mood penalty). Low Suppression raises rebellion chance per multiplier-stacked rebellion math (mood, weapon proximity, room edge, unattended factor, captive count, moving capacity) adapted from RimWorld's Ideology DLC slavery system. NEVER let Coerced NPCs near Tesla-arc weapons.

**Unwaveringly Loyal:** NPC class flag for high-faction-bond captives (faction Captains, named clergy, high-rank nobles, leader-instances). Cannot be recruited via Resolve reduction; their Resolve is fixed and immune to normal reduction. Can still be Coerced via Will reduction, or unlocked via: Resonance Amnesia (Tesla-coil bath that erases their faction-identity, cosmologically dark and expensive), Null-Bond Severance (Silence-priest ritual that severs home-culture bond, also dark), or slow Conversion (months of treatment and cultural assimilation).

**Will:** Per-NPC forced-recruitment threshold. Lower than Resolve. Reduced via confinement, Drift exposure, bargaining, or restraints. When Will reaches 0, the captive can be forced into Coerced status as a low-Loyalty NPC under ongoing Suppression maintenance. The fast-but-costly path. Adapted from RimWorld's Will stat.

---

## Faction Simulation

**Biome-to-Macro Mapping:** Worldgen rule binding cultural Macro Factions to appropriate geography. Karnish settle in pine-forest and northern mountain biomes. Veranthi settle on temperate plains and river valleys. Sethrai settle in subtropical river delta and adjacent coast. Halcyon's wreckage placed per Crash Site Placement rules. Ensures each playthrough's procgen world feels coherent with the setting.

**Contested Zone:** Geographic area where two or more Sub-Factions' Influence Zones overlap. Wars, raids, border-clashes, refugee crossings, and most Strain Event consequences play out here. Player can be caught in a contested zone mid-expedition and forced to make political choices on the fly. Halcyon's crash site often lands within or near a contested zone, which is part of how it gets dragged into local politics from day one.

**Crash Site Placement:** Procgen rule for where the wrecked Halcyon lands. Must satisfy: within walking distance (~3-5 game-days) of at least one named Karnish settlement, within mid-range (~7-10 game-days) of at least one Veranthi settlement, within long-range (~14-21 game-days) of at least one Sethrai settlement. Often lands within or adjacent to a Contested Zone to seed early-game political pressure. Biome bias toward forest-edge or river-valley terrain (places a real ship could plausibly crash without disintegrating).

**Cross-Macro Alliance:** Sub-factions can ally across Macro Faction lines. A Sethrai trade-house can ally with a Veranthi noble house against the Veranthi Crown. A Karnish hold can secretly aid Sethrai Quietists. These alliances drive the most narratively-rich political beats: betrayal, double-dealing, secret diplomacy. The macro identities are NOT monolithic blocs.

**Faction Codex:** The UI surface for political information. Lists known Sub-Factions and their parameters at the visibility level the player has earned. Macro Factions show their roll-up alongside expandable Sub-Faction breakdowns. Halcyon internal Sub-Factions are always fully visible. Foreign Sub-Factions display at Hidden / Vague / Approximate / Precise granularity per parameter. Updates in real time as background simulation ticks and player learns more.

**Faction Lifecycle:** Sub-Factions can be born and can die over the course of a playthrough. The political map at endgame looks materially different from world-gen.

- **Birth conditions:** religious schism Strain Event resolves in split (new Sub-Faction from the schism); successful rebellion against a faction leader (rebellion-faction becomes new Sub-Faction); mass defection wave (defectors form a new Sub-Faction with rolled-over State Vector elements); player sponsorship (Halcyon helps a charismatic local consolidate followers and a settlement).
- **Death conditions:** all Settlement Points captured or burned; complete absorption by a rival (treaty or conquest, State Vector transferred); Strain runaway (Cohesion drops below threshold, faction fragments into smaller groups or dissolves entirely).
- **Caps:** ~40 live Sub-Factions at any time (performance + cognitive ceiling); ~60 named memory slots so dead factions are remembered (last leader, fate, settlements-as-Ruins).

**Faction Influence:** The full surface of player actions that modify Sub-Faction State Vectors. Six categories, each targeting specific parameters. Effect model is Hybrid: tangible actions tick the State Vector immediately; slow-burn actions modify background tick rates and probabilities; cosmological actions are bi-temporal (immediate Drift Spike, multi-day faction propagation).

- **Diplomatic:** gifts (Tesla goods, food, medicine), trade treaties, embassy establishment, marriage alliances (Veranthi-coded), oath-swearing (Karnish-coded, guest-right binding), blood-tribute (Sethrai-coded, dark). Direct effect.
- **Military:** defending an ally's territory (lifts Mandate and Defensive Posture), raiding a rival (drops Reach and Martial Power), assassinating a leader (drops Mandate hard, may collapse Cohesion), backing a candidate in a Succession Crisis. Direct effect.
- **Economic:** trade-network integration (lifts Reach both parties), resource embargo (drops Reach, raises Strain), cure-trade during Pattern Sickness Outbreak (massive Mandate boost on grateful factions), Tesla technology transfer (large Reach boost but raises Strain via elite overproduction). Direct effect.
- **Information:** spy network deployment (gains Visibility, can drop opposed Cohesion via leaks), Tesla Receiver broadcast hijacking (Halcyon-only mid-game, regional shock), propaganda campaigns (slow Cohesion drift). Indirect effect (modifies background tick rates and probabilities).
- **Cosmological:** Resonance Web artifact placement, boss defeat in a region, Heart-Class Artifact reveal, supporting one side of the Sethrai Reformation cosmologically. Bi-temporal effect: immediate Drift Spike, multi-day faction propagation.
- **Cultural:** recruiting a Companion from a Sub-Faction (small Reach gain for Halcyon, small Cohesion drop for source), Coercion of an Unwaveringly Loyal NPC (huge Cohesion drop on source, massive faction-rep cost), Conversion of a captive (delayed Cohesion drop on source, lifted Cohesion in Halcyon). Mixed: recruitment direct, coercion direct, conversion indirect.

**Faction State Vector:** Per-Sub-Faction simulation parameters ticked by the Storyteller in the background. Each Sub-Faction carries six values that drive procgen political events. Macro Faction state is a roll-up of constituent Sub-Faction states. Adapted from the Dynamic Factions mod, framed by Turchin/Khaldun structural-demographic dynamics.

- **Cohesion:** internal unity. Texture varies by faction (Karnish hold-loyalty, Veranthi court intrigue, Sethrai priesthood unity, Halcyon Helios-Arcadian solidarity).
- **Reach:** territorial extent, alliance strength, trade-network span.
- **Mandate:** the leader's hold on power. Decays over time without legitimating events (military victory, ritual confirmation, heir production, prophet validation).
- **Martial Power:** military strength relative to neighbors.
- **Defensive Posture:** walls, guards, allied buffers, terrain advantage.
- **Strain:** Turchin's structural-demographic load. Elite overproduction plus popular immiseration. When Strain crosses thresholds, internal Strain Events fire.

**Faction Visibility:** Per-parameter knowledge level on a foreign Sub-Faction. Each State Vector parameter independently displays at one of four granularities based on player Integration: Hidden ("Status unknown"), Vague ("seems strong/weak/divided"), Approximate ("Martial Power high, Cohesion unknown"), Precise (numeric value with trend arrow). Halcyon has full visibility into its own internal Sub-Factions by default. Foreign visibility earned through Information Sources. Visibility decays slowly if not refreshed.

**Global Faction Events:** World-shaking events affecting multiple Macro Factions simultaneously, cascading to constituent Sub-Factions with tier-appropriate intensity. Storyteller-fired on the world calendar, not on player demand. Scaled by tech tier so pre-industrial factions are hit harder by some, immune to others.

- **Resonance Cascade:** catastrophic Tesla-weapon deployment in a regional conflict. Industrial-tier participants only. Devastating to tribal-scale factions in the affected area. Triggers wide-area Drift Spikes and Interference creep. Halcyon involvement is a Choice Point.
- **Pattern Sickness Outbreak:** Null Drift pandemic. Hits Karnish and Veranthi hardest; Sethrai have ritual immunity; Halcyon has Tesla medicine. Major Integrate lever (cure-trade affects every faction simultaneously and tests player ethics).
- **Veranthi Succession Crisis:** monarchic transition without clear heir, multiple court-faction claimants. Player can back a candidate.
- **Sethrai Reformation:** schism between Serpent-Priest (Broadcast) and Quietist (Silence) factions. Tilts the cosmological balance regionally.
- **Karnish Hold-Wars:** strain-triggered conflict between northern holds. Refugees flow to the Halcyon, recruit-rich but resource-stressing.

**Halcyon Internal Sub-Factions:** The Arcadian colony is itself a Macro Faction composed of Sub-Factions with their own State Vectors. Founding Sub-Factions named so far: Helios-Revivalists (lapsed-Helios Arcadians reasserting cult discipline; oppose coercion), Engineering Caucus (Asher-instance and the Tesla researchers; pro-deep-research, ambivalent on cosmology), Captain-Loyalists (Caius-instance's command structure; pragmatic, hold-the-line). More Sub-Factions can emerge over time via Strain Events and procgen.

**Influence Zone:** Geographic area of effective Sub-Faction control radiating from each of its Settlement Points. Radius scales with the Sub-Faction's Reach parameter; overlap with neighbors creates Contested Zones; gaps form wilderness or Void-Touched / Interference territory. Player faction-rep modifiers apply within a Sub-Faction's Influence Zone (Karnish hospitality bonus inside Pinewolf's zone, Sethrai trade-language bonus inside Black Iris's zone, etc.).

**Information Sources:** Inputs that grant or refresh Faction Visibility on foreign Sub-Factions. Trade relations (light, on Reach and Mandate). Diplomatic exchange or embassy (moderate, full vector). Companion from that Sub-Faction (high but biased toward their own faction's framing). Spy network or paid informants (high, expensive, can be discovered with faction-rep cost if blown). Tesla Receiver broadcasts (Halcyon-only, broad strokes on industrial-tier engagement, useless for tribal politics). Intercepted communications, captured Companion debriefs, prisoner interrogation (variable; per-source bias).

**Macro Faction:** Cultural-ethnic-political identity at the highest level. Four macros total: Karnish, Veranthi, Sethrai, Halcyon. Each composed of Sub-Factions. Macro relations roll up from Sub-Faction relations. Player reputation tracked at both levels (interactions move the Sub-Faction directly, Macro by a smaller amount). Used for narrative legibility ("the Karnish say...") and rolled-up trade and raid logic.

**Narrative Tick:** Storyteller-driven discrete State Vector update fired at narratively-appropriate moments on top of the regular Tick Rate schedule. Surfaces political drama with weight ("After three days of you backing the Veranthi heir candidate, Mandate ticks up by 5") rather than dribbling out continuous changes the player ignores. Storyteller selects timing based on player engagement, ongoing arcs, and dramatic pacing.

**Resolution Window:** The in-fiction time window a Strain Event takes to resolve. Storyteller fires the event with the window starting at fire-time. Player choices and actions during the window modify the resolving state. After the window expires, the State Vector resolves to its current value and the event closes. Window lengths by event type: leadership coup (game-day to game-week), succession crisis (game-week to game-month), peasant revolt (game-month), religious schism (game-season), settlement-war (game-week, battle plus resolution). Mechanism enforces narrative urgency without arbitrary game-clock pause.

**Ruin:** Physical-world remnant of a dead Sub-Faction's Settlement Point. Lootable. Often Void-Touched-haunted (the Sundering thesis: Sub-Faction collapse creates Interference residue at the abandoned site). Sometimes still named for the dead leader ("Halfdan's Hold, fallen"). Carries pre-collapse history as physical artifacts, journals, and named bones. Some Ruins become Sub-Faction birth sites for new factions reclaiming the territory.

**Settlement Point:** Named geographic location where a Sub-Faction lives. Each Sub-Faction holds 1-3 settlements. Examples: Pinewolf Hold (Karnish), Ironbound Hold (Karnish), Tarrick's Crown (Veranthi capital), Late Bloom Manor (Veranthi noble house), Black Iris Quay (Sethrai trade-house seat), Serpent's Spire (Sethrai sect-center). Each settlement contributes to its parent Sub-Faction's State Vector. Settlements can be captured, sacked, burned, or abandoned; settlement loss directly modifies the parent Sub-Faction's Martial Power, Defensive Posture, and Reach.

**Strain Events:** Internal Sub-Faction shocks the Storyteller fires when a Sub-Faction's Strain crosses a threshold. Examples: succession crises, peasant revolts, religious schisms, leadership coups, mass defection waves, court purges. Resolution shifts the Sub-Faction's State Vector and may shift relations with neighbors and the player. Each event has a Resolution Window matching its time scale. Player participation is Tiered by proximity and Integration:

- **Background:** distant or low-Integration foreign Sub-Faction. Player gets news after the fact.
- **Choice Point:** mid-distance or mid-Integration. Notification with 2-4 options that modify outcome probability without travel.
- **Quest:** near or high-Integration. Optional quest fires; player can travel, recruit, fight, negotiate. Highest narrative density.
- **Halcyon Internal:** always Quest-tier. Internal colony politics is non-skippable.

**Sub-Faction:** Named political unit within a Macro Faction. The level at which State Vectors actually live and at which political events fire. Approximately 20-30 across the world at game start, procgen-named and procgen-bordered. Examples: Pinewolf Hold (Karnish), Ironbound Hold (Karnish), House Var Tarrick (Veranthi crown faction), House of Late Bloom (Veranthi noble house), Black Iris Trade-House (Sethrai), Serpent-Priest Council (Sethrai), Quietist Underground (Sethrai), Helios-Revivalists (Halcyon), etc. Sub-Factions can be created, destroyed, fragmented, and merged over the course of a playthrough.

**Tick Rate:** Multi-rate hybrid update schedule for State Vector parameters. Each parameter updates at a rate matching its real political timescale.

- **Cohesion:** game-day.
- **Reach:** game-week.
- **Mandate:** event-driven only (legitimating or delegitimating events).
- **Martial Power:** game-week.
- **Defensive Posture:** event-driven only (fortifications, settlement capture, ally turnover).
- **Strain:** game-day, with threshold crossings firing Strain Events.

Halcyon Internal Sub-Factions tick faster (Cohesion game-hour, Strain game-day) because the player observes them constantly. Foreign Sub-Factions tick at standard rates. Storyteller additionally drives Narrative Ticks on top of the schedule for dramatic pacing.

---

## Design Layers

**Authored:** Constant across every playthrough. Mechanics, cosmology, lore framework, cultural archetypes, NPC role templates, item categories, boss archetypes, biome rules, the Halcyon crash premise.

**Character Ledger:** Structured, queryable record of who did what, who killed whom, who survived which event, who witnessed which Sundering, what Drift each character carries. Feeds both the Storyteller and NPC dialogue. Distinct from LLM context, which would hallucinate history.

**Emergent:** Simulated and story-told over time. Political dynamics (Turchin/Khaldun for factions), NPC memory and personal arcs, zone-creep into Normal Space, colony internal dynamics, narrative beats. RimWorld-school.

**Procgen:** Different every playthrough. World geography, specific NPC instances (including Arcadian crew), faction current state, cargo manifest specifics, item stats and naming, quest content, world history.

**Role Continuity:** Design principle for NPC-led arcs. Arcs and major quest structures attach to **roles** (Chief Engineer, Captain, Navigator, Merchant-Princess defector, etc.), not to specific procgen instances of those roles. When a Companion dies mid-arc, the arc passes to whoever next inherits the role, with their own personality bringing fresh perspective. Research notes and accumulated knowledge persist as physical artifacts in the world. Storyteller fallback fires opportunity events if no role-eligible NPC is currently alive (same anti-soft-lock pattern as Tesla cores). No specific Companion-instance is a soft-lock dependency. Individual deaths are emotionally real; structural arcs continue.

**Shared / Personal Split:** Design principle for arc and Companion content in multiplayer. Structural progress and accumulated knowledge are SHARED at the colony level (anyone contributes, everyone benefits). Companion relationships and dialogue histories are PERSONAL per player (each tracked separately in the Character Ledger). Parallel work at workshops accelerates colony progress. Storyteller beats split: colony-wide events fire for all, personal beats fire for one player (Storyteller picks by relationship strength or rotates), decision beats can be polled across stakeholders. Late-joining players inherit shared knowledge but begin personal arcs from neutral.

**Storyteller:** Meta-system that paces emergent events based on colony and world state. Modeled on RimWorld's AI Storyteller (Cassandra, Phoebe, Randy). Not necessarily an in-fiction named character; could be a beat-engine under the hood. **[TBD: difficulty profiles, in-fiction framing]**

---

## Named Persons in the Setting Doc

These names appear in the original setting doc but are **archetype illustrations, not fixed characters**. Each playthrough generates fresh instances filling these role templates. The traits listed are template-level (always present in the role); names and arc specifics are procgen.

**Arcadian Captain (e.g. Caius Vorrell):** Companion role. Template carries: clockwork prosthetic of own design, undiscussed drinking problem, promoted to command by acclamation after surviving the crash.

**Arcadian Chief Engineer (e.g. Edmund Asher):** Companion role. Template carries: the engineer eventually figures out that Tesla coils are broadcasting; the player can drive this arc.

**Arcadian Navigator (e.g. Vesper Wren):** Companion role. Template carries: saw something in the Void during transit (Silence proper or an Interference reef).

**Veranthi Monarch (e.g. Queen Solene Var Tarrick III):** Template carries: long reign without heir, miscarriages on record, court sorcerer access, has read Quantum-Shaman texts, knows more about the strangers from the sky than she lets on.

**Sethrai Merchant-Princess (e.g. Yarra of the Black Iris):** Candidate local-defector Companion archetype. Template carries: blood-tie to a Sethrai High Priest (Broadcast or Quietist sect, per procgen), fifteen years on the trade routes, multilingual including one tongue she does not speak loudly.

**Karnish Name Patterns (Halfdan Wolf-Friend, Brann Ironbound, Korin Stormcaller, Sigrid Pinewolf):** Name patterns of record for procgen Karnish NPCs. Not yet assigned role templates.

**Void-Touched Individual (e.g. Beren of Cold River Hold / the Whispering Hermit):** Encounter archetype. Originally Karnish, Sundered, now Interference residue wearing Karnish shape. Friendly until not. **[TBD: encounter mechanic]**

---

## Decisions Resolved Through Grilling

1. Game spine is Endure; other modes (Integrate, Solve, Sandbox, Escape) orbit.
2. Player is character-scale; colony is a sim layer beneath.
3. Colony stays home with party-formation overlay; max party 3-4, BioWare-style.
4. NPCs are tools AND quest-givers.
5. Design split: mechanics and archetypes authored, world and NPC instances procgen, narrative emergent.
6. Emergent storytelling layer modeled on RimWorld's AI Storyteller.
7. Default stakes are soft permanence with a Drift tick on respawn; Hardcore Mode is opt-in.
8. Cosmology is B + D + C: Broadcast (substrate, locally aware) + Silence (anti-reality) + Interference (the clash). Retooled from the Broadcast project, transposed from cyberpunk to Tesla-punk. Single-meter Void Corruption replaced by two-track Resonance Drift / Null Drift.
9. Zones manifest in three layers: Geographic (stable places), Weather (moving storms), Perceptual (visible only through Tesla, ritual, or Drift).
10. Drift is two independent meters (Resonance and Null, each 0 to 100). No offsetting between them. Decay is via time and targeted-decay actions only. Cooldown (not acting) is itself the survival consequence.
11. Drift accumulation is nonlinear (1x/2x/4x/8x by 30-point band), per-action with continuous fallback for ambient sources, and includes discrete Drift Spikes for narrative-weight events.
12. Drift decay is linear in time (1 point per game-hour baseline, both meters), modified by location and accelerated by activities (sleep, consumables, rituals, companion presence). Some locations have zero decay (Tesla workshop for Resonance, Silence flats for Null, Interference Zones for both).
13. Drift functions as a gating mechanism. Tesla and ritual gear are powerful but rationed; Conventional Gear remains relevant for the entire game. Players carry and use both categories at all stages.
14. Drift-Gated Abilities are active-while-at-threshold, not permanent unlocks. Five bands per meter (Quiet/Listening/Heard/Transmitting/Receiver and Steady/Slipping/Thinning/Coming-Apart/Sundered) with paired penalties and abilities at each band to keep trade-offs live.
15. Combat is pure real-time action, multiplayer-first, with no tactical pause. Melee is Directional (Mordhau/Chivalry/KCD lineage). Drift-Powered casting must be similarly skill-expressive; hotbar-press and click-spam are out.
16. Companion combat AI is baseline-plus-customization, with a real-time Command Wheel for issuing orders. No pause.
17. Drift-Powered Casting uses a tuning mini-game as the primary mechanic (skill-based, multiplayer-native, anti-spam), with Channel-and-Aim and Prime-and-Detonate as specialized modes. Tuning accuracy scales both Drift cost and effect strength.
18. Bosses are tiered across five levels (Tier 1 Early Void-Touched, Tier 2 faction-political, Tier 3 Regional Wall-of-Flesh, Tier 4 Faction-defining, Tier 5 cosmic Endgame). ~12-15 authored archetype templates across all tiers, procgen-instantiated per playthrough.
19. Each defeated boss permanently changes regional world state. Boss encounters admit multiple Resolution Paths (combat, negotiation, cosmological puzzle, bargained-with-becoming-its-priest). Not every boss is killable; some are changeable, not destroyable.
20. Companion customization is hybrid: stance presets (real-time toggleable) + equipment-driven adaptation + use-based skill growth with mentor-based specialization. Gambits explicitly excluded.
21. No character levels and no world scaling. Progression is four parallel vectors: Use-Based Skill (0-100 per individual skill), Knowledge Unlock (discovery-based), Crafting Tier (construction-based), Boss-Defeat Enhancement (permanent rewards from Tier 3+ bosses).
22. Boss-Defeat Enhancements are chooseable: player picks one of several rewards per defeated boss for replayability and build flexibility.
23. Tesla scarcity uses a two-tier component model: manufacturable parts (renewable from local materials) and irreplaceable Resonance Cores (finite per playthrough across three grades). Five-tier Core Acquisition Pathway ensures players never soft-lock; total cores capped by procgen world budget.
24. Optional off-by-default Manufacturing Mode toggle at game start (or unlockable via deep Engineer arc) enables a late-game Knowledge Unlock for Core manufacturing with deliberately expensive recipe to preserve scarcity feel.
25. Building uses voxel-with-structural-rules (Vintage Story school). Material types determine load-bearing capacity; Crafting Tier gates material access; Tesla devices are special voxel-machine components with placement and circuit-completion rules.
26. Environmental Physics overlays the voxel world: smoke, heat, cold, light, wind, rain and snow simulation. Drives survival pressures, construction requirements, and ambient Drift accumulation rates (e.g. unvented Tesla coils accelerate Resonance Drift on occupants).
27. Default Endure Pressures are Heavy (Vintage Story school: nutrition groups, granular temperature, injury, disease, sleep). Player-tunable down to Medium or Light presets at game start or via settings, with granular sub-toggles for advanced players.
28. Opening Sequence is three-act with no time-skip: ~15-20 min space tutorial aboard the intact Halcyon (integrated mechanics teaching, named officers met pre-crash), ~5-10 min witnessed Eating and crash sequence with first Drift Spike, then ~45 min immediate post-crash survival opening (player participates in muster, triage, shelter, first-contact with Karnish in real time). Player begins survival play with starting Drift carried from the witnessed Spike. The 78-survivor count is approximate; procgen crash outcome determines the actual starting roster. The colony is built by the player, not handed over.
29. Role Continuity: NPC-led arcs attach to roles, not specific procgen instances. Companion death is emotionally real but never soft-locks; the arc passes to whoever inherits the role, accumulated knowledge persists as physical artifacts, Storyteller fallback fires opportunity events if no role-eligible NPC is alive.
30. Multiplayer Shared/Personal Split: structural arc progress and knowledge are colony-shared; Companion relationships and personal dialogue history are per-player. Parallel work accelerates research. Storyteller beats split between colony-wide, personal (single-player), and polled-decision categories. Late-joining players inherit shared knowledge, begin personal arcs from neutral.
31. Recruitment of locals has five mutually non-exclusive Pathways (Quest, Relationship, Opportunity, Faction-Standing, Coercion). Coercion yields low-Loyalty NPCs with reputation costs across most factions (Sethrai approve) and internal colony dissent; redemption is possible but slow. Different players in multiplayer can pursue different paths with different NPCs.
32. Faction Simulation uses a six-parameter State Vector (Cohesion, Reach, Mandate, Martial Power, Defensive Posture, Strain) per faction, ticked by the Storyteller in the background. Strain crossings fire internal Strain Events; Global Faction Events affect multiple factions simultaneously and are tech-tier scaled. Adapted from the Dynamic Factions mod with Turchin/Khaldun framing.
33. Coercion mechanics adapt RimWorld prisoner/slavery systems. Two parallel stats: Resolve (voluntary, higher threshold) and Will (coerced, lower threshold). Coerced NPCs require ongoing Suppression maintenance with rebellion math (mood, weapon proximity, unattended factor, captive count, moving capacity). Unwaveringly Loyal class blocks Resolve reduction but admits Will reduction or slow Conversion redemption.
34. Faction model is Macro + Sub-Faction. Four Macro Factions (Karnish, Veranthi, Sethrai, Halcyon). Each composed of Sub-Factions with their own State Vectors (~20-30 total). State Vectors live at the Sub-Faction level; Macro state rolls up. Player reputation tracked at both levels. Halcyon has internal Sub-Factions (Helios-Revivalists, Engineering Caucus, Captain-Loyalists, emergent more). Cross-Macro Alliances allowed and load-bearing for political beats.
35. Faction Visibility is earned per Sub-Faction, per State Vector parameter. Four granularity levels (Hidden / Vague / Approximate / Precise). Information Sources gate visibility: trade, embassy, Companion (high but biased), spy network (high but costly and discoverable), Tesla Receiver (Halcyon-only, industrial-tier only), interrogation. Halcyon has full visibility into its own internal Sub-Factions by default. Faction Codex UI presents what's known.
36. Player Faction Influence operates through six action categories: Diplomatic, Military, Economic, Information, Cosmological, Cultural. Each targets specific State Vector parameters. Effect model is Hybrid: direct (immediate State Vector tick) for tangible actions; indirect (modifies background tick rates and probabilities) for slow-burn actions; bi-temporal for Cosmological (immediate Drift Spike, multi-day faction propagation).
37. Geographic representation is Layered: continuous voxel world map + procgen-placed Settlement Points + radial Influence Zones. Each Sub-Faction holds 1-3 named Settlement Points placed in biome-appropriate geography per Biome-to-Macro Mapping (Karnish in pine forests, Veranthi on plains, Sethrai in delta). Influence Zones radiate from settlements with radius scaled by Reach; overlaps form Contested Zones where wars and most political beats play out. Crash Site Placement is procgen-bounded: within walking distance of one Karnish settlement, mid-range of one Veranthi, long-range of one Sethrai, often adjacent to a Contested Zone.
38. Faction State Vector Tick Rate is Multi-rate Hybrid. Cohesion and Strain update per game-day. Reach and Martial Power update per game-week. Mandate and Defensive Posture are event-driven only. Halcyon Internal Sub-Factions tick at faster rates (Cohesion game-hour, Strain game-day) due to player proximity. Storyteller drives Narrative Ticks on top of schedule for dramatic pacing.
39. Strain Event participation is Tiered by proximity and Integration. Distant or low-Integration: Background news only. Mid: Choice Point with 2-4 options modifying outcome probability. Near or high-Integration: optional Quest with physical intervention. Halcyon Internal events: always Quest-tier. Each event has a Resolution Window matching its time scale; after the window expires, the simulation resolves with current state.
40. Sub-Factions follow a full Faction Lifecycle. Birth from schism, rebellion, defection, or player sponsorship. Death from settlement loss, absorption, or Cohesion-runaway fragmentation. Caps: ~40 live Sub-Factions, ~60 named memory slots. Dead Sub-Faction settlements become Ruins (lootable, often Void-Touched-haunted, often still named for the dead leader).
41. All seven Heart-Class artifacts canonically present every playthrough using original Broadcast doc names: Chorus Drive (emotion), Silence Kernel (memory), Axion Halo (perception), Architect's Key (creation), Null Engine (energy), Wound of Echoes (consciousness), Prime Array (existence). Procgen splits them: ~3-4 in Halcyon Cargo Manifest, ~3-4 planet-native. Some Hearts (notably Prime Array) tier-locked behind progression gates. Cargo Manifest total size is procgen per playthrough (~12 to ~25 artifacts across Heart, Voice, Eye, Hand classes).
42. Endgame Shape is Hybrid: five distinct endings gated by player history. Three game-ending cinematics (Merge, Restoration, Annihilation). Two transformed-sandbox (Ascension, Steward). Player history determines which endings are AVAILABLE; player picks from available ones at endgame. Each ending implies a moral and cosmological stance.
43. Endgame transition uses Hybrid Phase + Activation. Assembly of all seven Hearts at the Halcyon triggers an Endgame Phase (1-3 game-weeks) during which Drift dynamics intensify, factions react, and internal Halcyon politics escalate. Each of the five endings has its own activation mechanic (Merge: Prime Array central activation; Restoration: Architect's Key + Wound of Echoes harmonic; Annihilation: Silence Kernel + Null Engine sympathetic activation; Ascension: Tesla integration into Halcyon core; Steward: declare without activation). Player can switch intent mid-phase up until activation itself.
44. Endgame multiplayer resolution uses in-fiction faction politics. Halcyon Internal Sub-Factions back specific endings; the ending whose backing Sub-Faction has highest Mandate at activation moment wins. Players align with Sub-Factions during the Endgame Phase, build coalitions, sabotage rivals, run propaganda. Single-player handles trivially (player is leader of their dominant Sub-Faction). Edge cases: unanimous support fires automatic ending; no faction reaching Mandate threshold extends the phase; unbacked player intent fails to activate.

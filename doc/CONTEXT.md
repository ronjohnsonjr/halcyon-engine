# Engine Project (working name pending)

The forked-Godot agentic engine for survival-genre games on Godot 4.x. The flagship title is a steampunk-meets-cosmic-horror-meets-Hyborian-Age survival game with analog-tech progression and multi-world support via voidship travel. Operating mode is open-source side project with a graduation path to a funded product if traction warrants.

## Language

**Project Manifest**:
The logical sum of all declarative state for a project. Includes Godot-native files (`.tscn` scenes, `.tres` resources, `project.godot` config), **Entity Directories** for instantiable concepts, and **Registry Files** for pure-data tables. "Manifest" is a logical concept, not a single physical file.
_Avoid_: IR, Intermediate Representation, Spec, Blueprint, Plan.

**Entity Directory**:
A folder representing one instantiable thing in the project (a single NPC, a single mob, a single crafting station, the player). Contains separated files per aspect: `data.json` for designer data validated against a JSON Schema, `scene.tscn` for visual representation, and one or more `.gd` scripts for behavior.
_Avoid_: Entity folder, Asset bundle, Definition folder, Object directory.

**Authored Instance**:
A specific named entity in the Manifest. Examples: `npcs/elder_marcus/`, `sub_factions/aquilonia/`. Loaded directly into the world at startup; its URN is stable across playthroughs (e.g., `npc:elder_marcus`). Distinguished from a Template by representing exactly one runtime entity.
_Avoid_: Named entity, Specific entity, Concrete entity.

**Template**:
An Entity Directory in the Manifest that defines a recipe for procgen entities, not a specific entity itself. Examples: `npc_templates/karnish_villager/`, `sub_faction_templates/warring_kingdom/`. World generation instantiates Templates to produce runtime instances with procedurally generated URNs (e.g., `npc:karnish_villager_3f7a2b`). Carries variability fields (name patterns, personality ranges, drive distributions) that the Authored Instance schema does not.
_Avoid_: Prototype, Class, Type, Blueprint (Blueprint is also retired).

**Registry File**:
A single JSON file containing a flat table of entries for a pure-data concept that has no per-entry visual representation. Examples: `blocks.json`, `recipes.json`, `world_gen.json`, `storylets.json`. Validated against one JSON Schema.
_Avoid_: Manifest file, Data file, Catalog, Table.

**Reference URN**:
The typed cross-reference format used throughout the Project Manifest. Form: `<kind>:<id>` for entity and registry references, or `<kind>:<path>` for filesystem references. Examples: `item:bone`, `block:oak_log`, `npc:elder_marcus`, `tile:hex_4127`, `sub_faction:aquilonia`, `storylet:succession_crisis`.
_Avoid_: ID, ref, link, key.

**Manifest Index**:
A derived JSON file (`.cache/manifest_index.json`) built by walking the project's Entity Directories and Registry Files. Maps every **Reference URN** to its concrete target. Used both by the validator and by the engine at runtime. Not a source of truth.
_Avoid_: Cache, lookup table, registry (overloaded with Registry File).

**Authoring-Time Agent**:
An agent operating at development time over the Project Manifest, Scripts, scenes, tests, validation output, asset catalog, and execution logs. It is a co-developer for the game project, not an in-game character or simulation actor. By default it may autonomously modify project-level content inside a declared Agentic Run, while engine source, core schemas, ADR-level decisions, and destructive migrations remain human-gated.
_Avoid_: Agent (ambiguous), NPC agent, Runtime agent.

**Agentic Engine Loop**:
The engine-supported development loop in which one or more Authoring-Time Agents design, edit, validate, test, inspect results, and iterate until the requested project change is complete. The loop is a first-class engine capability, broader than an external repo workflow, and remains separate from the in-game LLM runtime that drives NPCs.
_Avoid_: Agentic workflow, AI mode, Automation loop.

**Agentic Run**:
The durable unit of work inside the Agentic Engine Loop. An Agentic Run has a goal, Permission Envelope, working branch or worktree, plan, agent and sub-agent transcript, Manifest and Script diffs, validation results, scene-test results, context provenance, relevant event-log excerpts, and final acceptance status. It is engine/workflow metadata, not Project Manifest content: it references Manifest URNs and file paths but does not validate as game content or ship into runtime builds. It is the thing the editor can display, resume, cancel, audit, or promote into a commit or pull request.
_Avoid_: Session, Chat, Job, Task (too generic).

**Permission Envelope**:
The structured boundary for an Agentic Run. Contains the run's allowed paths or Reference URN kinds, allowed tool categories, forbidden operations, budgets, required gates, human-gated paths, provider/cost class, and sub-agent policy. Context Pack configuration, Provider Configuration, workflow schemas, and permission defaults are human-gated by default because they shape future agent behavior. The creator-facing UX should be natural-language friendly, but the engine enforces a structured envelope.
_Avoid_: Prompt, Policy (too broad), Permissions (too generic).

**Context Pack**:
A project-specific bundle of glossary, design, convention, and skill files loaded by Authoring-Time Agents during Agentic Runs. The engine provides the mechanism; each game project provides its own content. The approved source of truth is `.halcyon/context_pack.json`; the engine may suggest additions from conventional paths, but does not broadly ingest every project document by default. Context Packs may list explicit read-only external reference roots for optional search, but those roots are not project content and are not required for builds. For the flagship title, the Context Pack includes the game-design glossary and design documents, while Halcyon's fiction remains project-specific rather than baked into the generic engine layer.
_Avoid_: Lore pack, Prompt pack, Memory (too broad).

**Provider Configuration**:
Non-secret workflow metadata describing provider preferences for Authoring-Time Agents and optional runtime adapters. Stored in `.halcyon/provider_config.json`. Secrets and credentials live outside the repository in user/server configuration or environment variables.
_Avoid_: Context Pack (knowledge context), Credentials, Secrets.

**Flagship-First Generalization**:
The engineering rule that the flagship game proves engine needs before the engine extracts stable survival-framework abstractions. Build concrete Halcyon vertical slices first, then generalize schemas, tools, and editor surfaces from demonstrated needs. Avoid generic engine abstractions that are not demanded by the flagship game or near-term survival-modder use.
_Avoid_: Generic-first architecture, Platform-first design.

**Script**:
A GDScript file written by the agent that implements imperative game logic. The agent has full filesystem access to read, write, and edit scripts; Claude-Code-style.
_Avoid_: Leaf Behavior, Behavior Template, Custom Logic, Handler.

**World**:
A single planet. Represented as a Goldberg hex-sphere. Each world has its own hex-sphere tiling, its own sub_factions, its own climate, and its own cosmic-horror state. The flagship game eventually supports multiple Worlds connected via voidship travel; the MVP ships with a single World.
_Avoid_: Planet, Map, Globe, Level.

**Hex Tile** (or just **Tile** when context is clear):
One face of the Goldberg hex-sphere tiling that represents a **World**. Most Tiles are hexagonal; exactly 12 per World are pentagonal (a topological requirement of any spherical hex tiling). A Tile owns a region of voxel chunks at the player scale and is the addressable unit for the temporal layer (a sub_faction claims Tiles, a biome covers Tiles, a storylet's precondition can match against Tiles).
_Avoid_: Region, Zone, Chunk (Chunk is the voxel-scale unit, not the planet-scale unit), Province.

**Macro Faction**:
The top-level cultural-political identity that contains SubFactions. The flagship game has four Macro Factions: Karnish, Veranthi, Sethrai, and Halcyon. Macro-level state is computed as a roll-up from member SubFactions.
_Avoid_: Faction (too broad), Culture (not the same as political identity), Civilization.

**SubFaction**:
A named political unit within a Macro Faction. Owns one or more Settlement Points and an Influence Zone over Hex Tiles. Carries a Faction State Vector: Cohesion, Reach, Mandate, Martial Power, Defensive Posture, and Strain. SubFactions rise, expand, contend, fragment, merge, and die as emergent dynamics of those values. Named individual NPCs may be associated with SubFactions, but the SubFaction itself is an aggregate.
_Avoid_: Faction (Faction may later mean something narrower; reserved), Nation, Kingdom, Empire (those are flavor names, not the engine concept), Civilization (too general).

**Faction State Vector**:
The six-parameter state carried by each SubFaction: Cohesion, Reach, Mandate, Martial Power, Defensive Posture, and Strain. The Storyteller and Temporal Layer use it to drive Strain Events, Influence Zones, faction visibility, and political change.
_Avoid_: Turchin variables, Polity state, Stats (too generic).

**NPC**:
A named or notable character whose decisions are driven by the engine's in-game LLM runtime (Gemma 4 2B class, server-side authoritative). NPCs have persistent memory across sessions, remember the player, can ally with other NPCs against third parties, and exercise asymmetric magic-vs-tech agency. Per ADR-0008, only a small set of demonstration NPCs at MVP run the full LLM-planning loop; the rest run the simpler dialogue-plus-affinity-flag variant.
_Avoid_: Character, Citizen, Person, Agent (overloaded with the authoring-time agent).

**Wildlife**:
A non-intelligent creature governed by traditional behavior trees, with no LLM in the loop. Includes animals, monsters, mindless cosmic horrors, and any creature whose behavior is well-described by scripted rules. Distinct from **NPC** specifically because no LLM runtime is invoked for Wildlife.
_Avoid_: Mob (deprecated; see Flagged Ambiguities), Creature, Monster (Monster is a flavor type, not the engine concept).

**Role**:
A stackable trait bundle that an **NPC** can hold. Each Role carries fields like default disposition baseline, status in sub_faction (elite, commoner, outsider, etc.), eligible actions, and behavior baselines. Multiple Roles stack on a single NPC; their combined fields drive disposition, behavior, and which storylets are eligible. Storybricks lineage. Defined separately from individual NPCs so trait bundles can be reused across many NPCs.
_Avoid_: Trait, Class, Profession (Profession may later mean a narrower job concept; reserved), Type.

**Drive**:
A weighted goal or aversion held by an **NPC**. Each Drive has an id (e.g., `protect_village`, `avoid_outsiders`) and a weight in [0, 1]. The storylet manager queries Drives in storylet preconditions to determine narrative salience. The temporal layer can aggregate Drives across NPCs in a SubFaction to bias sub_faction-level dynamics. Storybricks lineage; conceptually utility-AI weights.
_Avoid_: Motive, Goal, Desire, Need.

**Storylet**:
A unit of narrative content with typed preconditions (queries against world state and the event log), a salience function (dynamic priority depending on state), effects (mutations to apply on selection), content (text, dialogue, scene id), a cooldown, and a tier (Major / Minor / Flavor). Per the Versu / Façade design lineage. The narrative layer selects Storylets per narrative tick based on salience under satisfied preconditions.
_Avoid_: Quest, Event, Encounter, Scene (all overloaded).

**Spatial Layer**:
The engine subsystem that owns planetary representation. Per ADR-0017, the planet has a **dual spatial structure**: a **Voxel Substrate** (cube-sphere, where blocks live) and a **Sim Overlay** (Goldberg hex-sphere, where sub_factions and biomes are scoped). The two are queried via a coordinate lookup function. Also owns the coordinate transformations between player-scale and planet-scale.

**Voxel Substrate**:
The cube-sphere that holds all voxel data per ADR-0017. Six face-local voxel grids using the Adjusted Spherical Cube (ASC) projection. Player movement, building, and mining happen here. Voxel chunks are 32³ blocks, face-local. Depth uses a shell-based scheme toward the core. Distinct from the **Sim Overlay**, which is a logical structure queried by lookup.

**Sim Overlay**:
The Goldberg G(4,0) hex-sphere serving as the logical structure for sub_faction ownership, biome assignment, storylet preconditions, and structural-demographic simulation per ADR-0010 (amended by ADR-0017). 162 hex tiles. Not a voxel-storage unit; queried via `hex_id_of(voxel_position)` against a precomputed face-indexed lookup table.

**Pentagon Site**:
One of 12 topologically singular points on the planet, produced by the alignment of the cube-sphere and the Goldberg overlay so that 8 cube corners coincide with 8 of 12 Goldberg pentagons. Divides into **Corner Pentagons** (8 cosmic-horror eruption sites at cube corners, where geometry is most distorted) and **Face-Center Pentagons** (4 civilizational seed sites at cube face centers, where the major cultures' founding sub_factions are placed). All 12 are presented mechanically as **Wonder Regions** with distinct ambient and storylet eligibility.

**Wonder Region**:
The mechanical presentation of a **Pentagon Site**: a zone where geometry is visibly distorted and the distortion is framed in-fiction as the seams of reality, the breaches, the places where the void leaks through. Distinct ambient lighting, weather rules, biome eligibility, and storylet availability. Replaces the abstract "cosmic horror site" concept from earlier drafts.

**Temporal Layer**:
The engine subsystem that owns scheduled world updates, SubFaction State Vector simulation, Strain Event firing, and per-**NPC** LLM planning. Writes to the shared event log.

**Narrative Layer**:
The engine subsystem that owns the Storylet registry, the Storylet evaluator (filter-by-precondition, score-by-salience, pick-per-tier, respect-cooldown), and character memory bindings.

## Relationships

- The **Project Manifest** is the source of truth for declarative state. Realized as Godot-native files, **Entity Directories**, and **Registry Files**.
- **Scripts** live alongside `data.json` and `scene.tscn` in Entity Directories, or as cross-cutting files in `scripts/`.
- The engine's three layers (**Spatial**, **Temporal**, **Narrative**) communicate via the shared append-only event log.
- A **World** carries both a **Voxel Substrate** (cube-sphere, where blocks live) and a **Sim Overlay** (Goldberg hex-sphere, 162 hex tiles, where SubFactions and biomes are scoped). The two are aligned so 8 cube corners coincide with 8 of 12 Goldberg pentagons, yielding 12 **Pentagon Sites** which are presented mechanically as **Wonder Regions**. **SubFactions** own contiguous sets of hex tiles on the Sim Overlay. **NPCs** and **Wildlife** are instantiated by hex tile.
- The **Authoring-Time Agent** participates in the **Agentic Engine Loop** through **Agentic Runs** over the Manifest, Scripts, scenes, tests, validation output, asset catalog, execution logs, and project-specific Context Packs. The in-game LLM runtime (separate subsystem) drives NPCs at runtime.

## Example dialogue

> **Creator:** "Make Aquilonia start strong but collapse to civil war if the king dies without an heir."
> **Agent:** Updates `sub_factions/aquilonia/data.json` (high starting Cohesion, high Mandate, low Strain). Writes a new **Storylet** `storylets/heirless_succession.json` whose preconditions are `sub_faction:aquilonia.ruler.alive == false AND sub_faction:aquilonia.heir == null`, salience scales with current Cohesion (high Cohesion makes the crisis more dramatic), effects apply a Cohesion penalty and spawn faction-NPCs with claimant Roles. Validator confirms the SubFaction URN resolves. No changes to other SubFactions, no changes to the block library.

## Flagged ambiguities

- "IR" (Intermediate Representation) was used in the original research report. Resolved: this is now **Project Manifest**.
- "Leaf Behavior" was used in the original research. Resolved: superseded entirely by **Script**.
- "Behavior" alone is not a domain term. Use **Script**, or describe what the script does in plain English.
- "Manifest File" was used as an umbrella in earlier drafts. Resolved: split into **Entity Directory** and **Registry File**.
- "Items" boundary: items live in `items.json` (Registry File) with optional `world_drop_scene` references.
- "System" (day/night, hunger, health) is a third minor pattern: scripts in `scripts/systems/` plus tunables in another Registry File or per-entity `data.json`. Treated as a principled exception.
- "Mob" was used in early grilling rounds as a catch-all. Resolved: split into **NPC** (LLM-driven, persistent memory, factional) and **Wildlife** (behavior-tree, no LLM). "Mob" is no longer used as a domain term.
- "Agent" is overloaded. Resolved: the **Authoring-Time Agent** (the development-time agent participating in the Agentic Engine Loop) is distinct from the **in-game LLM runtime** (the Gemma 4 2B class model driving NPCs). When ambiguous, qualify explicitly.
- "Tile" can refer to a **Hex Tile** (planet scale) or to texture tiles in art assets. In the engine's domain language, **Tile** alone means **Hex Tile**.

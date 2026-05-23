# Research Context: Existing Agentic AI Game Engine Tech

## Purpose

You are researching existing open-source technology that could help build this project.

The goal is not to find one complete product that already does everything. The goal is to identify OSS projects, papers-with-code, engine plugins, editor extensions, agent harnesses, simulation frameworks, and tool patterns that already solve pieces of the system so we can borrow, fork, adapt, or avoid reinventing them.

Prioritize projects with permissive licenses, active maintainers, clear architecture, and code that can be studied or reused. Include less active projects if they are architecturally instructive.

## One-Sentence Project Summary

We are building a forked Godot 4.x agentic engine for survival-genre games, with a first-class authoring-time AI agent loop, declarative game manifests, procedural voxel planets, faction simulation, storylet-driven narrative, and a separate in-game LLM runtime for a small number of persistent NPCs.

## Operating Assumptions

- This is an open-source, self-hostable side project first.
- Managed hosting, proprietary backend infrastructure, and marketplace/platform obligations are out of scope for the MVP.
- The engine should be useful to survival-game creators, not a generic all-genre game engine.
- The flagship game, Project Halcyon, proves the engine's abstractions before they are generalized.
- Godot 4.x is the base engine.
- The project can fork Godot where needed, but should avoid unnecessary divergence from upstream.
- Existing OSS should be preferred over bespoke systems when it is technically and legally suitable.

## High-Level Product Shape

The engine has two distinct AI-related surfaces:

1. **Authoring-Time Agent**
   - A development-time co-developer operating over project files.
   - Similar in spirit to Claude Code, Cursor agents, and other code-editing agents.
   - It can edit game content, scripts, scenes, schemas, tests, and fixtures inside a declared permission boundary.
   - It runs validation, scene tests, and deterministic checks, then produces diffs for human review.

2. **In-Game LLM Runtime**
   - A runtime gameplay subsystem that drives a small number of important NPCs.
   - It is server-authoritative.
   - It uses an LLM as a planner, but execution is through scripted, allowlisted game actions.
   - It is separate from the authoring-time agent and should not be confused with it.

## Engine Architecture

The engine is organized around three major runtime layers, plus cross-cutting authoring infrastructure.

### Spatial Layer

The spatial layer owns planetary representation and player-scale terrain.

Target shape:

- Voxel survival-game world.
- Planet represented as a cube-sphere voxel substrate.
- Goldberg hex-sphere overlay for simulation-level tiles.
- Hex overlay is used for faction ownership, biomes, storylet preconditions, and world simulation.
- Voxel substrate is used for building, mining, movement, and player-scale interaction.
- Coordinate lookup maps voxel positions to simulation tiles.

Research should look for:

- Godot voxel terrain systems.
- Spherical voxel worlds.
- Cube-sphere terrain implementations.
- Goldberg / geodesic sphere tiling libraries.
- Planetary terrain streaming.
- Voxel chunk persistence.
- Hex-grid simulation overlays.
- Techniques for hiding or embracing cube-sphere edge distortion.

Known relevant candidate:

- Zylann's `godot_voxel` is likely the first system to inspect for voxel runtime reuse.

### Temporal Layer

The temporal layer owns scheduled world updates and simulation.

Target shape:

- Multi-rate world tick.
- Faction state simulation.
- Deterministic event log.
- Server-authoritative simulation.
- NPC planning cadence.
- Persistence through snapshots plus event tail.

Faction simulation uses a six-value state vector:

- Cohesion
- Reach
- Mandate
- Martial Power
- Defensive Posture
- Strain

Research should look for:

- Open-source faction simulation frameworks.
- Strategy-game political simulation systems.
- Dwarf Fortress / RimWorld-like storyteller or event systems.
- ECS or simulation scheduling frameworks suitable for Godot.
- Deterministic simulation and replay systems.
- Event sourcing in games.
- Multiplayer authoritative server examples.
- SQLite-backed world persistence.

### Narrative Layer

The narrative layer owns storylet selection, narrative salience, character memory binding, and event-driven story beats.

Target shape:

- Storylets are content units with preconditions, salience scoring, cooldowns, and effects.
- Storylets query world state and the event log.
- Narrative selection is dynamic, not a static branching dialogue tree.
- NPC memory and character knowledge are derived from authoritative event history.

Research should look for:

- Storylet engines.
- Quality-based narrative systems.
- Versu / Façade lineage systems.
- Ink, Yarn Spinner, Dialogic, Twine, StoryNexus-like engines, and Godot integrations.
- Rule engines or query systems that can evaluate preconditions over game state.
- Character memory systems that distinguish known facts from global truth.

### Cross-Cutting: Project Manifest

The Project Manifest is the logical sum of all declarative project state.

It is not one file. It includes:

- Godot-native files such as `.tscn`, `.tres`, and `project.godot`.
- Entity Directories for instantiable concepts.
- Registry Files for pure-data tables.
- JSON Schemas for validation.
- A build-time Manifest Index that maps typed Reference URNs to concrete files.

Entity Directories represent instantiable things, such as one NPC, station, boss, settlement, or wildlife creature.

Typical shape:

```text
npcs/elder_marcus/
  data.json
  scene.tscn
  behavior.gd
```

Registry Files represent flat pure-data tables, such as:

```text
items.json
blocks.json
recipes.json
biomes.json
storylets.json
roles.json
```

Cross-references use typed Reference URNs:

```text
item:bone
block:oak_log
npc:elder_marcus
tile:hex_4127
sub_faction:aquilonia
storylet:succession_crisis
```

Research should look for:

- Data-driven game authoring systems.
- Godot editor tooling for schemas, custom resources, and content validation.
- JSON Schema validation integrated into game pipelines.
- Asset databases and manifest/index systems.
- Modding manifest formats.
- Content-addressed asset catalogs.
- Tools that map between declarative game content and engine-native scenes/resources.

## Authoring-Time Agent System

This is the most important research area.

Target shape:

- A Claude-Code-style local harness.
- CLI plus MCP server.
- Standard file/search tools.
- Engine-specific tools layered on top.
- Permission policy: Allow / Deny / Prompt.
- Durable agent work records called Agentic Runs.
- Human approval for risky paths.
- Validation and test gates before a run is marked ready.
- Editor surface for browsing, resuming, accepting, rejecting, or cancelling runs.

The intended tool surface includes:

- File/search tools: shell, read file, write/edit file, glob, grep.
- Engine tools: validate Manifest, query Manifest Index, describe schema, run scene test, search asset catalog.
- Higher-level tools: spawn sub-agent, write todos, invoke skills.

### Agentic Run

An Agentic Run is the durable unit of autonomous authoring work.

It records:

- Goal
- Permission Envelope
- Branch or worktree
- Plan
- Agent and sub-agent transcript
- Diffs
- Validation results
- Scene-test results
- Context provenance
- Relevant event-log excerpts
- Final acceptance status

Lifecycle:

```text
Draft -> Approved -> Running -> Blocked | Failed | Ready For Review -> Accepted | Rejected | Cancelled
```

Default local storage convention:

```text
.halcyon/runs/<run_id>/
  run.json
  transcript.jsonl
  validation.json
  scene_tests.json
  context.json
  event_log_excerpt.jsonl
  diff.patch
```

Research should look for:

- Claude Code-compatible OSS implementations.
- Cursor-like or Aider-like local coding agents.
- MCP servers for game engines.
- Agent run metadata formats.
- Permission models for coding agents.
- Tool allowlist / denylist systems.
- Human-in-the-loop autonomous coding workflows.
- Multi-agent orchestration with isolated worktrees.
- Agent evaluation harnesses for code-editing tasks.
- Agent transcript/event storage formats.
- Agent UI panels inside editors or game engines.

Known relevant candidate:

- `github.com/ultraworkers/claw-code` and its docs are especially important because the current design intentionally follows a clean-room Claude Code-style architecture.

## In-Game LLM NPC Runtime

This is separate from the authoring-time agent.

Target shape:

- Server-side authoritative inference.
- LLM-as-planner with scripted execution.
- Only a small number of demonstration NPCs run the full LLM loop at MVP.
- Most NPCs use simpler dialogue, affinity, and scripted behavior.
- NPCs have persistent memory across sessions.
- NPCs can remember the player, form alliances, and participate in faction politics.
- NPC action tools are allowlisted.
- Runtime must degrade gracefully when inference is slow or unavailable.

Research should look for:

- OSS LLM NPC frameworks.
- Godot LLM integrations.
- Unity/Unreal LLM NPC projects if architecture is portable.
- Inworld / Convai / NVIDIA ACE style patterns, even when not OSS.
- Skyrim/Fallout mod projects such as Mantella and related open-source companions.
- Memory architectures for NPCs.
- Vector-store plus relational memory hybrids.
- LLM tool-call allowlisting in games.
- Latency management for NPC dialogue.
- Server-authoritative LLM action planning.
- Safety patterns for preventing hallucinated game actions.

Important pattern to identify:

- The LLM should propose intent or plans.
- The game executes only validated, scripted actions.
- The game state and event log remain authoritative.

## Flagship Game: Project Halcyon

The engine is proven through Project Halcyon, a survival game with these pillars:

- Tesla-punk crashlanded survivors.
- Cosmic horror.
- Voxel building and survival.
- Procedural worlds.
- Persistent named NPCs.
- Faction politics.
- Storyteller-driven emergent narrative.
- Single-player and small cooperative multiplayer.

The player is one of the crash survivors. The crash site becomes the colony.

The world includes:

- The Arcadians: industrial / Tesla-punk crash survivors.
- Local cultures with Hyborian-Age technology and magic.
- Cosmic forces framed as Broadcast, Silence, and Interference.
- Drift meters representing exposure to those forces.
- Sub-Factions that rise, fragment, merge, and collapse.
- Storylets that fire from simulated world state.

Comparables and inspirations:

- Vintage Story
- Minecraft
- RimWorld
- Dwarf Fortress
- Kenshi
- Crusader Kings 3
- Conan Exiles
- Frostpunk
- Sunless Sea / Sunless Skies
- Arcanum
- Outer Wilds
- Valheim
- Space Engineers

Research should use these as reference points, not as constraints.

## What We Want To Borrow

Look for borrowable pieces in these categories.

### Engine / Godot

- Godot 4 editor plugin architectures.
- Godot custom dock panels.
- Godot GDExtension examples.
- Godot headless testing.
- Godot scene validation.
- Godot server builds.
- Godot WebSocket / ENet multiplayer examples.
- Godot asset import and catalog tooling.

### Voxel / Planet Tech

- Godot voxel terrain.
- Voxel chunk streaming.
- Persistent voxel storage.
- Cube-sphere worlds.
- Spherical gravity.
- Planet LOD.
- Goldberg / geodesic tiling.
- Voxel-to-region lookup.

### Agentic Authoring

- Local coding-agent harnesses.
- MCP servers.
- Permission and approval systems.
- Agent run history.
- Tool execution logs.
- Worktree-based agent isolation.
- Test-gated autonomous code loops.
- Editor-integrated agent UX.

### Data-Driven Game Content

- JSON Schema pipelines.
- Manifest/index systems.
- Data-driven entity definitions.
- Godot scene/resource generators.
- Modding formats.
- Content validation and quarantine.
- Reference resolution systems.

### Narrative / Simulation

- Storylet engines.
- Rule/precondition evaluators.
- Emergent narrative directors.
- AI Storyteller-like systems.
- Faction simulation.
- Event logs.
- Character memory ledgers.
- Deterministic replay.

### Runtime LLM NPCs

- LLM NPC memory.
- Tool-call constrained action systems.
- Dialogue plus gameplay-action separation.
- Server-side inference orchestration.
- Local inference options.
- Graceful fallback behavior.

### Asset Pipeline

- CC0 / permissive asset catalog tooling.
- glTF normalization.
- Attribution generation.
- Content-addressed asset stores.
- License scanners for game assets.
- Search/index systems for art/audio assets.

## Strong Research Signals

A project is especially interesting if it has one or more of these traits:

- Godot 4 support.
- Permissive license such as MIT, Apache-2.0, BSD, or MPL-compatible usage.
- Works locally without a hosted SaaS dependency.
- Has a CLI or programmatic API.
- Has an editor integration pattern.
- Separates declarative content from imperative scripts.
- Has validation or schema support.
- Records agent/tool execution history.
- Uses event sourcing, deterministic replay, or snapshot plus log persistence.
- Shows a mature permission or approval model for agent actions.
- Supports modding or user-authored content.
- Is small and understandable enough to fork.

## Weak Signals / Red Flags

Treat these as risks, not automatic rejection:

- Proprietary-only SDK with no local/self-hosted path.
- AGPL or unclear license that may complicate engine reuse.
- Dead project with no build instructions.
- Unity/Unreal-only code with engine-specific assumptions.
- LLM NPC demo that lets the model directly mutate game state.
- Agent framework with no permission model.
- Agent framework that stores essential state only in a hosted backend.
- Voxel engine with no persistence or streaming story.
- Narrative engine limited to static branching dialogue only.
- Simulation code that is nondeterministic by design.

## Suggested Search Queries

Use combinations of these terms:

```text
Godot 4 voxel terrain open source
Godot voxel engine persistence chunk streaming
Godot spherical planet voxel
cube sphere voxel terrain open source
Goldberg polyhedron hex sphere library
geodesic hex sphere game map open source
Godot editor plugin AI assistant MCP
Godot MCP server
Claude Code open source implementation
local coding agent permission model open source
MCP coding agent worktree open source
agent run metadata autonomous coding open source
AI game engine open source agentic
LLM NPC Godot open source
LLM as planner scripted execution game NPC
Mantella source code NPC memory
storylet engine open source
quality based narrative engine open source
Godot storylet plugin
RimWorld storyteller open source implementation
faction simulation game open source
event sourcing deterministic simulation game
JSON schema game content validation Godot
mod manifest schema game engine open source
content addressed asset pipeline game assets
CC0 asset catalog tooling open source
```

## Evaluation Rubric

For each promising project, return:

- **Name**
- **URL**
- **License**
- **Primary language / engine**
- **Maturity**
- **Maintainer activity**
- **What piece it could help with**
- **Why it matches this project**
- **What would need adaptation**
- **Integration risk**
- **Reuse mode**: study only, copy small pattern, vendor library, fork, plugin, or direct dependency
- **Confidence**: high / medium / low

Use this rough scoring:

```text
5 = Directly reusable with modest adaptation.
4 = Strong architectural match; code likely borrowable.
3 = Useful reference, but significant adaptation needed.
2 = Interesting idea only.
1 = Not useful except as cautionary example.
```

## Preferred Output Format

Group findings by category:

1. Agentic authoring / coding-agent infrastructure
2. Godot editor and MCP integrations
3. Voxel, spherical world, and terrain tech
4. Data manifest, schemas, validation, and modding
5. Storylets, narrative systems, and faction simulation
6. Runtime LLM NPC systems
7. Asset pipeline and license tooling
8. Cautionary examples and dead ends

For each category:

- Top 3-10 projects.
- Short explanation of how each could fit.
- License and maintenance status.
- Recommended next action.

At the end, include:

- Best immediate candidates to inspect deeply.
- Components that probably need to be built from scratch.
- Components that should be deferred until after the MVP.
- Any terminology or architecture from existing projects that should influence this design.

## Current Best Guesses To Verify

These are hypotheses, not facts.

- Godot voxel terrain reuse likely starts with Zylann's `godot_voxel`.
- Authoring-time agent harness reuse likely starts with `claw-code`, Aider, OpenCode-style agents, and MCP server patterns.
- Runtime NPC architecture should learn from Mantella-style game mods and commercial patterns like Inworld / Convai / NVIDIA ACE, but avoid SaaS lock-in.
- Storylet tooling may be more likely to provide design patterns than drop-in code.
- Faction simulation may need custom implementation, borrowing concepts from strategy and colony-sim projects rather than direct libraries.
- The Manifest / schema / validation layer may need custom engine integration, but can borrow from JSON Schema tooling, modding systems, and asset database patterns.

## Critical Distinctions To Preserve

- Do not conflate the Authoring-Time Agent with in-game NPC AI.
- Do not treat LLM output as authoritative game state.
- Do not assume the Project Manifest is a single file.
- Do not assume the engine is generic for all genres; MVP scope is survival games.
- Do not prioritize hosted SaaS systems unless they reveal reusable architecture.
- Do not prioritize "AI generates assets" systems; asset generation is out of scope.
- Do not optimize for massive MMO scale. Target single-player and small cooperative multiplayer first.

## If You Find A Near-Match

If an existing project appears to overlap heavily with this vision, investigate:

- Whether it is truly open source.
- Whether it supports Godot or can be adapted.
- Whether it separates authoring-time AI from runtime AI.
- Whether it has a permission/audit model.
- Whether it is self-hostable.
- Whether it can work with deterministic validation and replay.
- Whether its content model can map to Entity Directories, Registry Files, Reference URNs, or a similar manifest/index pattern.

The highest-value finding would be an OSS project that already combines:

- Godot editor integration,
- local agent tooling,
- content validation,
- scene testing,
- and durable agent run records.

But partial matches are expected and useful.


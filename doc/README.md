# Halcyon

Working name for a forked-Godot agentic engine for survival-genre games on Godot 4.x.
Flagship title: a steampunk-meets-cosmic-horror-meets-Hyborian-Age survival game with
analog-tech progression and multi-world voidship travel.

Operating mode: open-source side project with a graduation path to a funded product if
traction warrants.

## Layout

- `docs/CONTEXT.md` - canonical engine/tooling vocabulary (Manifest, Entity Directory,
  Reference URN, schemas). Read this first for engine work.
- `docs/ENGINEERING.md` - engineering reference and architecture notes.
- `docs/adr/` - architecture decision records (ADR-0001 onward).
- `docs/sessions/` - dated design-session summaries.
- `docs/game-design/` - flagship-title game design (separate from the engine vocabulary):
  - `PROJECT_HALCYON_DESIGN.md` - the comprehensive game design document.
  - `GLOSSARY.md` - game-design glossary (setting, cosmology, drift, factions, endgame).
- `schemas/` - JSON Schemas for all entity and registry data.
- `samples/` - sample Project Manifest data: registry files plus folder-per-entity
  authored instances and templates.

Two glossaries, two scopes: `docs/CONTEXT.md` is the engine/tooling language; `docs/game-design/GLOSSARY.md` is the in-fiction game vocabulary. They intentionally don't overlap.

## Conventions

- Entity Directories hold one instantiable thing (`data.json` + `scene.tscn` + `.gd`).
- Registry Files are flat JSON tables for pure-data concepts (`blocks.json`, etc.).
- Cross-references use typed Reference URNs (`item:bone`, `npc:elder_marcus`).
- See `docs/CONTEXT.md` for the full vocabulary and the terms to avoid.

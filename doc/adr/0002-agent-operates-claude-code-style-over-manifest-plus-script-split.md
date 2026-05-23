# Agent operates Claude-Code-style over a Manifest plus Script split

The agent has full filesystem access to the project tree. It writes, reads, and edits GDScript files directly without sandboxing. Declarative state (block library, recipes, scenes, mobs, world generation, input map) lives in the **Project Manifest** and is mutated through typed tool calls. Imperative game logic lives in **Scripts** (`.gd` files) and is written freely.

This supersedes the original research recommendation of "Manifest plus sandboxed leaf scripts," which was rejected for capping the product ceiling and fighting against modern LLM capabilities.

## Considered Options

- **Manifest-only (no code emission).** Rejected: cannot express novel game mechanics. The ceiling is too low for the "lower the technical ceiling for creators" product goal, because a low ceiling for the AGENT is a low ceiling for the creator.
- **Manifest plus sandboxed leaf scripts.** Rejected. The original research recommendation. Sandbox infrastructure is significant engineering effort that fights against LLM strengths and caps the product ceiling without proportional benefit for an open-source side project.
- **Manifest plus freely-written scripts (static analysis only, no sandbox).** Subset of the selected option; we use this for the Script half.
- **Manifest plus Claude-Code-style agent loop.** Selected. Manifest for declarative state, full filesystem access for imperative logic.
- **Code-first (Manifest as derived artifact only).** Rejected: loses the differentiator vs Rosebud and similar code-emission products. The declarative subset genuinely benefits from typed schemas and structured tool calls.

## Consequences

- No sandbox runtime infrastructure to build. No AST validator for restricting GDScript features. A significant engineering surface is eliminated.
- Auditability comes from review, the agent event log, and git diff. Not from runtime restriction.
- Reproducibility comes from logging prompts, tool calls, and file diffs. Not from deterministic code generation.
- The Manifest schema must draw a clean boundary between what is declarative and what is imperative. This is the load-bearing schema design work and remains open.
- The agent has two tool surfaces: typed Manifest tool calls (e.g., `define_block`, `define_recipe`, `set_world_generation`) and filesystem operations (read, write, edit, glob, grep) similar to Claude Code's tool set.
- The "graduation path" for technical creators improves. Scripts are real GDScript files, not sandboxed snippets, so a creator who learns GDScript can edit them directly without leaving the engine.

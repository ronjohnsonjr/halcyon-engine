# NPC schema: hybrid structured fields with freeform personality

NPCs are defined by an Entity Directory containing `data.json` with a hybrid schema: structured engine-readable fields (`id`, `display_name`, `polity` URN, stackable `role` URN references, weighted `drives`, `allowlist` of permitted tool calls, starting `memory` seed) plus a freeform `personality` string field that the in-game LLM runtime receives in its system prompt for tone, voice, and texture.

The structured fields are inspectable by the validator (URNs resolve, allowlist actions exist) and readable by other engine subsystems (the Turchin temporal layer reads roles to determine elite/commoner stratification, the storylet manager reads drives to check storylet preconditions, the multiplayer authoritative state synchronizes the structured fields). The personality field is opaque to the engine and consumed only by the LLM.

## Considered Options

- **A. Freeform persona prose only.** Inworld/Mantella style. Most flexible for the LLM, least inspectable for the validator and other subsystems. Rejected: gives up auditability.
- **B. Storybricks-style fully structured (Drives, Changes, Parts, Exits, Roles).** Most auditable, most composable. Rejected: limits the LLM's expressive range in dialogue; structured-only persona produces wooden conversation.
- **C. Hybrid structured fields plus freeform personality.** Selected.
- **D. Convai-style narrative graph.** Heavier authoring burden than MVP requires; defer the graph-shaped declaration for v1.0+ if storylet manager isn't sufficient.

## Schema sketch (illustrative, not final)

```json
npcs/elder_marcus/data.json:
{
  "id": "elder_marcus",
  "display_name": "Elder Marcus",
  "polity": "polity:aquilonia",
  "roles": ["role:village_elder", "role:cimmerian_elder", "role:traditionalist"],
  "drives": [
    { "drive": "protect_village", "weight": 0.9 },
    { "drive": "preserve_old_ways", "weight": 0.7 },
    { "drive": "avoid_outsiders", "weight": 0.4 }
  ],
  "allowlist": [
    "set_affinity",
    "become_old_friend",
    "share_lore",
    "request_quest",
    "turn_hostile",
    "propose_alliance",
    "reveal_polity_secret"
  ],
  "memory": {
    "starts_with": [
      "Marcus remembers the day the voidship fell from the sky.",
      "Marcus's wife was lost to the deep places three winters ago."
    ]
  },
  "personality": "Soft-spoken, weighs every word. Quotes proverbs from the Cimmerian elders. Believes outsiders bring change and change brings the cold of the deep places. Will warm to a player who shows respect for the old ways. Quotes proverbs even when angry."
}
```

## Consequences

- **Role becomes a first-class concept** with its own schema. A Role is a stackable trait bundle (Storybricks lineage) defined in either `roles.json` (Registry File) or `roles/<role_id>/data.json` (Entity Directory). Format decision pending; current expectation is Registry File since Roles are pure data with no per-instance scenes or scripts. Multiple Roles stack on an NPC; their combined fields drive default disposition, status in polity, eligible actions, and behavior baselines.
- **Drives are engine-readable.** The storylet manager queries drives in storylet preconditions ("storylet `village_threatened` is salient if any NPC with drive `protect_village` weight > 0.5 has observed a threat to their polity"). The Turchin temporal layer can also bias polity-level dynamics by aggregating NPC drives (a polity dominated by traditionalist drives resists modernization, etc.).
- **Allowlist is enforced at two layers.** The validator confirms every action in the allowlist is a defined tool call at authoring time. The engine validates at runtime that the LLM's proposed tool call is in the NPC's allowlist before executing.
- **Memory seed bootstraps the NPC's long-term vector store.** The `memory.starts_with` array is embedded into the vector store at NPC instantiation, providing initial context before any player interactions accumulate.
- **Personality is LLM-only.** No other subsystem reads it. The validator does not constrain its contents beyond length limits.
- **Manifest schema gains an NPC schema and a Role schema.** These are written next.
- **The schema is straightforward to extend.** Adding new structured fields (e.g., `combat_stats`, `appearance`, `dialogue_examples`) is additive. Adding new Roles is data-only.

# Polity simulation uses 4-variable Turchin model (N, S, W, E)

Each polity carries four state variables for the structural-demographic simulation: **N** (population), **S** (state strength), **W** (sociopolitical instability), and **E** (elite count). Additional derived or auxiliary state (solidarity / asabiyyah, treasury, ruler NPC reference, heir NPC reference, owned tiles) lives alongside the four core ODE variables.

The four-variable model extends the standard Turchin (2005) three-variable model (N, S, W) with explicit elite dynamics from Turchin (2003) chapter 7.2.3. Elite overproduction is the math behind Khaldun's three-generation collapse pattern, which is core to the flagship game's "Hyborian-Age civilizations rising and falling" theme.

## Considered Options

- **A. Minimal 2-variable (N, S).** Rejected: insufficient for visible cycles without significant tuning.
- **B. Standard 3-variable (N, S, W).** Rejected: loses elite overproduction, which is the dynamic that makes the Khaldun three-generation pattern feel right.
- **C. Extended 4-variable (N, S, W, E).** Selected.
- **D. Per-stratum population pools.** Deferred to v1.0+: out of MVP scope.

## Consequences

- The temporal layer integrates the 4-variable ODE system per polity at a per-game-decade tick via RK4 (per ADR-0009).
- Storylet preconditions can query any of N, S, W, E and their ratios (e.g., `succession_crisis` salience scales with E/N ratio, capturing intra-elite competition).
- Authored Polity instances and Polity Templates both specify initial values for the four variables plus per-polity coefficient overrides (asabiyyah gain rate, elite reproduction rate, state overhead β, tax efficiency ρ).
- The world DB stores the current state of all four variables per polity, mutating each decade-tick. The Manifest stores only initial values.
- Visualization tooling (per ADR-0009's "must visualize well" principle) ships a phase-plot debug window showing (N, S) or (N, W) trajectories per polity, plus a tile-overlay heat map of polity ownership over time.
- Implementation cost: roughly one extra ODE relative to the 3-variable model. Minor.

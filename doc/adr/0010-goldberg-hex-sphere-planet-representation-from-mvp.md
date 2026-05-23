# Goldberg hex-sphere planet representation, from MVP

The planet's spatial structure is a Goldberg polyhedron (a sphere tiled by 12 pentagons and many hexagons) from MVP. Voxel chunks bind to individual hex tiles, providing locally-Euclidean player-scale geometry per tile. The planet is a real sphere: walking far enough in any direction returns the player to their starting position. Voidship navigation (post-MVP) operates at the sphere level.

This supersedes the earlier recommendation to defer the hex-sphere and ship a flat or toroidally-wrapped world at MVP. The user's design requirement is that worlds feel like real worlds and that circumnavigation is possible from MVP onward, even if rare in practice. A toroidal placeholder does not satisfy this and would have required architectural replacement later; building the sphere correctly from the start is the honest path.

## Considered Options

- **Visual fakery on a finite flat world.** Rejected: player cannot actually circumnavigate.
- **Toroidal flat-wrapped world.** Rejected: topologically not a sphere; breaks down once voidship views the planet from outside; would require replacement to ship full Goldberg later.
- **Spherical coordinate system only (latitude/longitude/altitude), no Goldberg geometry.** Rejected: latitude/longitude meets at poles, creating non-uniform voxel chunk sizing near the poles. Goldberg exists specifically to avoid this; using sphere-coords without Goldberg buys most of the implementation cost without the structural benefit.
- **Goldberg hex-sphere from MVP.** Selected.

## Consequences

- **Voxel runtime work expands significantly.** Zylann's `godot_voxel` is Euclidean cubic; binding voxel chunks to hex tiles requires non-trivial engineering. Specifically: chunk-to-tile mapping, seam handling at tile boundaries (voxel grids of adjacent tiles must align), local gravity orientation per tile (each tile's "down" points toward planet center), and rendering of distant tiles with proper spherical curvature.
- **Per-tile chunk regions.** Each hex tile maps to a region of voxel chunks. The chunk coordinate system is local to the tile. When the player crosses a tile boundary, the engine performs a seamless coordinate transformation.
- **Planet size at MVP is the next decision and is open.** A small Goldberg (G(1,1) is 32 tiles total; G(2,2) is 92; G(4,4) is 252) is feasible for MVP. Earth-scale (tens of thousands of tiles) is post-MVP. The exact subdivision level needs grilling.
- **Reference implementations are sparse.** Andy Gainey's *Experilous* blog (now on Wayback Machine) is the closest documented approach. Outer Wilds, Astroneer, and Spore handle spherical worlds but none are voxel survival games at production scale. We are doing something rare; expect to invent.
- **Phased plan impact.** P2 (voxel runtime integration) was estimated at 4 weeks for a forked Zylann. With Goldberg integration, P2 expands meaningfully (estimate: 12-16 weeks, pending feasibility audit). Total MVP timeline extends roughly 2-3 months as a result.
- **Multi-world is now a clean extension.** Each world is a separate Goldberg hex-sphere. Voidships travel between hex-spheres. The architecture supports the eventual multi-world design without further restructuring.
- **Spatial layer's planet structure is locked.** Climate, plate tectonics, erosion, and hydrology remain out of MVP scope but can be added incrementally as features of the Goldberg structure.

## Open

- **Subdivision level / planet size at MVP.** Goldberg G(m,n) parameter choice. Cascades into total tile count, per-tile region size, total chunk count, and whether a single playthrough can plausibly circumnavigate.
- **Tile-to-chunk binding details.** Chunk grid alignment at tile boundaries; seam handling algorithm.
- **Local gravity model.** Real per-tile down-toward-center, or simplified local-flat-gravity per tile with the engine handling the spatial transform invisibly.
- **Zylann integration scope.** How much of Zylann's module do we fork vs. wrap vs. replace.

## Amended by ADR-0017

The Goldberg G(4,0) hex sphere now serves exclusively as the **civilization-simulation overlay**: polity ownership, biome assignment, storylet preconditions, and structural-demographic dynamics (ADR-0015) all continue to operate on the 162-tile hex structure. Voxels live separately on a cube-sphere per ADR-0017. The two structures are rotated so that 8 cube corners coincide with 8 of 12 Goldberg pentagons, producing 12 unified topological singularities (Pentagon Sites). Planet radius bumps from 4 km to 6 km. The original commitment to circumnavigability and the 162-tile sim granularity stand; only the voxel-grid interpretation changes. The "tile-to-chunk binding details" and "seam handling algorithm" open items above are resolved at the cube-sphere level by ADR-0017 (per-cube-face local frames, ~1° edge dihedrals at 6 km), not at the Goldberg level. The "local gravity model" open item is resolved: gravity is per-cube-face-local in voxel space, with the cube-sphere projection handling the spherical-curvature transform; per-hex-tile gravity is irrelevant because voxels do not live on hex tiles.


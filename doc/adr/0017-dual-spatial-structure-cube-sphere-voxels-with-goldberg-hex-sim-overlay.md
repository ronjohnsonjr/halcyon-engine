# Dual spatial structure: cube-sphere voxels with Goldberg hex sim overlay

The planet uses two parallel spatial structures. The **voxel substrate** is a cube-sphere using the Adjusted Spherical Cube (ASC) projection (Dimitrijević 2016): six face-local voxel grids, each clean and Minecraft-precision flat in its own frame. The **simulation overlay** is the Goldberg G(4,0) hex sphere from ADR-0010: 162 hex tiles serving as the unit of polity ownership, biome assignment, storylet preconditions, and Turchin/Khaldun structural-demographic dynamics. The two structures are rotated relative to each other so that **8 of the 12 Goldberg pentagons coincide with the 8 cube corners**, and the remaining 4 pentagons fall on cube face centers. This yields **12 unified topological singularities** which become first-class world sites with both geometric and narrative meaning. Planet radius increases from 4 km (ADR-0010) to **6 km** to push cube-edge dihedral kinks below the player-noticeable threshold for typical structure spans (~1° per edge at 6 km).

## Status

Accepted. Supersedes the voxel-grid interpretation of ADR-0010 (the Goldberg structure now serves as sim overlay only). Amends ADR-0016 (`tile_id` is now a voxel-region addressing scheme, with `hex_id` as a separate query function).

## Context

ADR-0010 committed the planet representation to Goldberg G(4,0), motivated by the Fractal Philosophy three-layer architecture (Jacob O'Neill) and the requirement that the planet be a real walkable sphere with circumnavigable surface. ADR-0016 added a hybrid `tile_id + tile-local offset` coordinate scheme for player position and voxel chunk addressing.

The genre constraint surfaced subsequently: the flagship game is a block-based survival game in the Minecraft / Vintage Story tradition, where players will dig precisely and build large multi-block structures that span tile boundaries. Adjacent Goldberg hex tiles at G(4,0) have face normals differing by 4-7°, which means voxel grids on neighboring hex tiles cannot align. A 100 m wall built across a hex-hex seam visibly deflects several blocks. This violates the player contract that voxel-survival games have established over the last fifteen years.

A deep research pass (the cube-sphere vs Goldberg report) established three concrete facts:

1. **No shipped block-based voxel survival game uses a Goldberg sphere.** All commercial-released attempts (Planet Nomads, Blocky Planet, Planetcraft, PlanetSmith, StarMade) converged on cube-sphere variants.
2. **Goldberg dihedral cannot be oriented out.** Every hex-hex edge carries intrinsic curvature; only global subdivision reduces it, and meaningful reduction requires ~10,000+ tiles which destroys the polity-sim granularity.
3. **Voxel substrate and simulation substrate need not share geometry.** This is the Dwarf-Fortress / Minecraft pattern: storage grid and logical-region grid are independent and connected only by a coordinate-lookup function.

## Considered Options

- **Option 1: Pure Goldberg voxels.** Rejected. No precedent in the survival genre, 3-6 months of voxel-runtime fork work plus ongoing rebase burden, fundamental geometric incompatibility with Minecraft-precision building.
- **Option 2: Pure cube-sphere.** Rejected. Throws away the Goldberg-based civilization sim, the Fractal Philosophy three-layer architecture, and the existing schema work (cultures, polities, polity templates already designed around hex tiles).
- **Option 3: Dual structure with axis-aligned Goldberg overlay.** Selected.
- **Option 4: HEALPix unification.** Considered. The 12-base-pixel topology is elegantly matched to the 12-pentagon count, and equal-area properties are attractive. Rejected for this project because the existing sim work is implemented on Goldberg; switching now would require redoing the polity/biome/storylet architecture for marginal gain. Worth revisiting if a future project starts from zero.

## Decision

Voxels live on a cube-sphere with the Adjusted Spherical Cube (ASC) projection. The Goldberg G(4,0) hex sphere remains as the civilization-simulation overlay. The two structures are rotated relative to each other so 8 cube corners coincide with 8 of 12 Goldberg pentagons. Planet radius is 6 km.

The cube-sphere axes are aligned to the Goldberg construction's icosahedral frame such that the cube's 8 vertices map to 8 of the icosahedron's 12 vertices (i.e., 8 of 12 Goldberg pentagons). The remaining 4 Goldberg pentagons land on 4 of the 6 cube face centers. The 2 cube faces without a face-center pentagon are unmarked.

Each cube face hosts a face-local voxel grid stored in 32³-voxel chunks (per Zylann's standard chunk size). Six face-local octrees (or one custom multi-face streamer) handle streaming. Depth uses a shell-based scheme (à la Blocky Planet / Jacco Bikker): voxel chunks subdivide vertically as they approach the core to keep voxel proportions reasonable, with a hollow core below a minimum-radius shell.

Coordinate addressing per ADR-0016 stands. `tile_id` refers to a voxel region (cube-face chunk address). `hex_id_of(voxel_region_id, local_offset)` is a separate query function that returns the Goldberg hex tile at any given point. The hex lookup is precomputed once via spherical Voronoi over the 162 hex centers and stored as a face-indexed lookup table (~1 KB per cube face).

## Lore-significant sites

The 12 unified pentagons are named **Pentagon Sites**. They divide into two classes:

- **Corner Pentagons (8 sites):** at cube corners, where 3 cube faces meet and voxel-grid topology has degree-3 vertices instead of degree-4. These are the geometrically most distorted points on the planet. Narratively, they are the **cosmic-horror eruption points**: places where reality is thinnest, where the Sundering came from, where voidships fell when the void between worlds chose to spit them out. The 8 Corner Pentagons resolve the previously-deferred decision on cosmic-horror site placement: each Corner Pentagon hosts one primary cosmic-horror site, possibly with associated Void-Blighted Wastes biome rings.
- **Face-Center Pentagons (4 sites):** at cube face centers, with the cleanest local geometry except for their pentagonal hex neighborhood (5 hexes meet instead of 6). Narratively, they are **civilizational seed sites**: ancient observatories, the original capital cities of the major cultures, the places where the Karnish first held council and the Sethrai first built ziggurats. Procedural polity generation seeds the major cultures' founding polities at face-center pentagons preferentially.

Both classes are presented mechanically as **Wonder Regions**: zones where the player sees visibly distorted geometry (the cube-edge kink, the pentagon's 5-hex neighborhood) and is expected to interpret the distortion as a feature, not a bug. Wonder Region biomes have unique ambient lighting, weather patterns, and storylet eligibility.

## Consequences

**Voxel cleanliness:** the vast majority of the planet's surface has clean cubic voxel grids in their face-local frames. Players can build long straight structures without visible bends across cube face interiors. The only visible geometric artifacts are at the 12 cube edges (where two faces meet, ~1° kink at 6 km radius) and the 12 pentagon sites.

**Goldberg simulation preserved:** all existing ADRs and schema work that depends on hex tiles (ADR-0009 three-layer architecture, ADR-0015 Turchin polity dynamics, polity/polity_template schemas, biome/storylet eligibility) continues to operate unchanged. The hex overlay is a logical structure queried via lookup; no voxel-level consistency is required.

**Cosmic-horror placement resolved:** ADR-0017 anchors the 8 primary cosmic-horror sites at the Corner Pentagons. World generation can place additional minor cosmic-horror sites procedurally, but the 8 primary sites are fixed topologically. This removes the previously-deferred "cosmic horror placement specifics" open item.

**Civilizational seed sites anchored:** the 4 Face-Center Pentagons become the founding-polity sites for the major cultures (Veranthi, Sethrai, Karnish + one additional culture or wilderness-marked-by-monolith). Procedural polity generation uses these as preferred seeds; the player's crashed *Halcyon* lands elsewhere (no Pentagon Site collision).

**Wonder Region mechanic unlocks:** the 12 pentagon sites are presented as gameplay features. Distorted geometry is in-fiction explained as the seams of the world, the breaches, the places the gods left. This converts a mathematical artifact into a design hook.

**Planet radius bump to 6 km:** circumference becomes ~37.7 km, walking the equator at 5 km/h takes ~7.5 hours. Each Goldberg hex tile covers ~2.8 km², roughly 1 km on a side. This is a more believable continental scale than R=4 km gave.

**Engineering cost:** ~5-6 weeks of additional fork work over a flat voxel base (per the research report's estimate). Six face-local `VoxelTerrain` instances or one custom multi-face streamer atop Zylann's `godot_voxel`. ASC projection in a `VoxelGenerator` subclass. Hex-overlay lookup table precomputed at world-gen and held in memory (162 entries × small record = trivial). Streaming model is per-cube-face proximity-driven, behaving like a flat `godot_voxel` world within each face.

**Schema cleanup needed:** `world_gen.schema.json` must add fields for cube-sphere projection (`projection: "asc" | "spherified_cube"`), planet voxel radius, pentagon-to-cube assignment, and shell depth parameters. The existing `subdivision_m`/`subdivision_n`/`radius` fields stay (now describing the Goldberg overlay). `cosmic_horror_sites` becomes a list of authored or procedural overrides on top of the 8 Corner Pentagon defaults.

**Multi-world support clean:** each world is its own cube-sphere + Goldberg overlay; multi-world voidship travel scales trivially to N worlds.

**Follow-up open items:**

- Shell-based depth scheme parameters (minimum voxel size at core, shell count, subdivision rules).
- Per-face streamer vs custom multi-face implementation choice (engineering preference, deferred to P2).
- Visual treatment of cube-edge kinks (shader-blended seam vs visible-but-narratively-explained).
- Wonder Region biome schemas (do they extend existing biomes with overrides, or are they their own biome category?).
- Civilizational seed assignment authored vs procedural at world-gen (4 cultures + 4 face-center pentagons is suspiciously clean; consider authored mapping).

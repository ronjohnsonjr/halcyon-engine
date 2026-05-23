# Coordinate frames on the hex-sphere: hybrid tile_id + tile-local offset

Player and voxel positions on the Goldberg hex-sphere (per ADR-0010) are addressed as a structured pair: a `tile_id` (integer index into the per-World hex-tile graph) plus a `local_offset` of `(x, y, z)` coordinates in that tile's local Euclidean frame. The tile's local frame has Z+ pointing away from planet center (gravity is local-down); X and Y span the tile's surface footprint with axis orientations fixed at world generation.

Voxel chunks are stored entirely in tile-local coordinates. Crossing a tile boundary increments the player's `tile_id` and rebases the local_offset to the new tile's frame, computed by the engine's tile-graph subsystem; no continuous coordinate teleport is visible to physics or animation. World-space coordinates (for rendering across tiles or networking distance checks) are computed on demand from `(tile_id, local_offset)`.

## Considered Options

- **A. Always tile-local.** Rejected: coord-teleport at boundary crossings is awkward for physics and animation.
- **B. Always global.** Rejected: loses Zylann's cubic-Euclidean voxel-chunk assumption (substantial fork work) and floats lose precision at planet scale (poor scaling to larger worlds later).
- **C. Hybrid: tile_id + tile-local offset.** Selected.
- **D. Cube-mapped projection (replace Goldberg).** Rejected: would reopen ADR-0010 and lose the structural simulation benefits of the hex-sphere.

## Consequences

- **Zylann's voxel module compatibility.** Chunks remain cubic Euclidean within a tile. Zylann's internal chunk addressing is reusable per-tile with minimal modification. The engine fork adds a tile-graph layer that owns the per-tile chunk-set ownership.
- **Network address normalization.** Multiplayer state sync keys chunks by `(tile_id, chunk_local_offset)`. Exact integer addressing rather than floats; replication consistency improves.
- **Gravity model is trivial per-tile.** "Down" is always tile-local `(0, 0, -1)`. The hex-sphere structure determines what direction that points in world-space, but per-tile physics doesn't need to know.
- **Streaming is straightforward.** Load `(current_tile, ring_of_adjacent_tiles)`. When `player.tile_id` changes, shift the loaded set.
- **Tile boundary seams have a 4-7° dihedral mismatch** (the angle between adjacent face normals at G(4,0)). Voxel grids on adjacent tiles don't perfectly align. Seam handling is a follow-up grilling pass.
- **Vertical extent per tile** needs specifying: max depth (probably ~256 blocks below the tile's surface) and max height (probably ~128 blocks above) for MVP. Deferred.
- **Player visible horizon at R=4km** is roughly 7.1km from a 1.7m-tall vantage. Player can see roughly 11 adjacent hex tiles at once, which constrains the streaming radius (load ~1-2 rings of adjacent tiles around the current).

## Amended by ADR-0017

`tile_id` now refers to a **voxel region on the cube-sphere** (cube-face chunk address), not a Goldberg hex tile id. The Goldberg hex overlay is queried via a separate function `hex_id_of(voxel_region_id, local_offset)` that returns the hex tile at any given point on the planet. The hybrid addressing model from this ADR is unchanged in form: `(tile_id, local_offset)` still uniquely identifies player and voxel positions, and crossing a voxel-region boundary still rebases the local offset to the new region's frame. Only the underlying grid topology is reinterpreted: regions are cube-face chunks, not hex tiles.

Consequences updated by ADR-0017:

- **Tile boundary seams have ~1° dihedral mismatch** at cube edges (R=6 km), not 4-7° at hex edges. Hex-tile boundaries no longer exist at the voxel level, so per-hex seam handling is moot.
- **Network address normalization** continues to work: chunks are still keyed by `(voxel_region_id, chunk_local_offset)`, exact integer addressing.
- **Gravity is per-cube-face-local**, with the cube-sphere projection handling the spherical curvature. "Down" is the negative face-normal direction within each face.
- **Streaming** loads cube-face chunks by proximity, behaving like a flat `godot_voxel` world within each face. Cross-cube-face transitions occur at 12 edges (instead of the many hex-hex edges).
- **Visible horizon at R=6 km** is ~8.7 km from a 1.7 m vantage; player can see roughly half a cube face at once.


# Multiplayer is self-hosted, Luanti-style

The engine ships an authoritative headless dedicated-server build. Creators host it themselves on a VPS, home machine, or LAN. There is no platform-operator infrastructure: no managed lobby, no TURN relay, no per-world VMs, no matchmaking service.

This matches the operating-model decision to run the project as an open-source side project, eliminates platform-operator obligations, and gives survival-genre games the authoritative-server protection they need for cheat resistance.

## Considered Options

- **P2P only (WebRTC + STUN).** Rejected: NAT traversal fails 10 to 30% of the time, and survival games need authoritative-server cheat resistance that P2P cannot provide.
- **Self-hosted dedicated server (Luanti/Minetest model).** Selected.
- **Federated public lobby (community-run matchmaking).** Rejected: overengineered for MVP.
- **Hybrid P2P-first, self-host fallback.** Deferred: eventual goal, but doubles the testing surface at MVP.

## Consequences

- The engine includes a `--headless --server` build target.
- Server-side persistence uses SQLite per world.
- The engine ships ENet (UDP, desktop) and WebSocket (WSS, browser) transports on the same server process.
- No P2P, no NAT traversal, no managed services in scope for MVP.
- Community is responsible for running and discovering servers, mirroring the OSS game ecosystem norm.

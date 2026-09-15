# Phase 0 — Repository Bootstrap Record

## Decisions

- Product name: Beacon
- GitHub repository: `hudsonhelm/Beacon`
- Repository visibility: private
- Upstream: `Ylianst/MeshCentral`
- Default/upstream branch: `master`
- Production/default branch: `master`
- Integration branch: `develop`
- MSP hierarchy: fixed Customer → Site → Device with tags

## Verified Baseline

- Exact upstream commit: `9f328938a355b778b037435dbc61ef89731f71ad`
- MeshCentral package version: `1.2.5`
- License: Apache-2.0
- Official Docker assets present: `docker/Dockerfile`, `docker/compose.yaml`, `docker/config.json.template`, and `docker/README.md`

## Scope Boundary

Phase 0 changes repository governance and documentation only. It does not brand the application, alter MeshCentral behavior, configure infrastructure, or deploy test/production environments.

## Validation

- `npm ci` completed successfully from the pinned upstream lockfile: 221 packages installed and audited.
- `npm ls --depth=0` resolved all declared top-level dependencies.
- `node --check meshcentral.js` and `node --check meshuser.js` passed.
- The inherited dependency audit reported three moderate-severity advisories. They are recorded as upstream baseline findings and were not changed during repository bootstrap.
- Docker is not installed on the bootstrap workstation, so container-image construction remains a Phase 3 validation on the selected Docker host or CI runner.

## Exit Checklist

- [x] Hudson-controlled fork exists.
- [x] Upstream remote is configured.
- [x] Upstream default branch and exact baseline are recorded.
- [x] Apache-2.0 license and notices are preserved.
- [x] Project plan is stored at `docs/PROJECT_PLAN.md`.
- [x] Beacon-specific changelog and upstream procedure exist.
- [x] MSP hierarchy decision and rationale are recorded.
- [x] Repository dependency and source validation passes.
- [ ] Baseline tag and bootstrap commit are pushed.
- [ ] Integration branch is pushed.

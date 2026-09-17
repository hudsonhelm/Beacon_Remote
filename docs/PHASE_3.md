# Phase 3 — Build Beacon From Our Fork

## Status

Phase 3 completed on September 17, 2026. The first Hudson-controlled Beacon Remote image was built from this repository on the prepared VPS, its source metadata was verified, and it passed an isolated HTTPS startup smoke test. No persistent test or production application environment was deployed in this phase.

## Source and Image Identity

| Item | Verified value |
|---|---|
| Image name and tag | `beacon-remote:0.1.0-hudson.1` |
| Image ID | `sha256:e04c1450f0f54a654a4457ed981369c9a8e4b6202fa7d50b0eeed197c231fc1b` |
| Image size | 495,304,137 bytes |
| Beacon source commit | `eb8869064d7771565368fecd7d578e657d3061d0` |
| Upstream MeshCentral commit | `9f328938a355b778b037435dbc61ef89731f71ad` |
| Upstream package version | `1.2.5` |
| Build timestamp | `2026-09-17T16:24:14Z` |
| Server source directory | `/opt/beacon/builds/eb8869064d7771565368fecd7d578e657d3061d0` |

The image is local to the VPS. It is not tagged `latest`, and no upstream image was substituted for the Hudson build.

## Upstream Docker Review

The official Alpine Dockerfile, entrypoint, configuration template, Compose example, and image-build workflows were reviewed before changing the build. Upstream `master` was nine commits ahead of Beacon's recorded baseline, but its Docker implementation had not changed across those commits. Phase 3 therefore retained the pinned MeshCentral 1.2.5 baseline rather than silently incorporating unrelated upstream work.

Beacon continues to reuse the upstream multi-stage Alpine build. The only packaging change adds OCI labels for:

- Hudson image version
- exact Beacon Git revision
- UTC build timestamp
- upstream MeshCentral version and revision
- repository source, license, name, and description

The inherited `docker/compose.yaml` remains an upstream reference example and still names an upstream `latest` image. It must not be used as a Beacon test or production deployment manifest. Phase 4 must introduce a separate environment-specific Compose definition pinned to a Hudson tag or digest.

## Reproducible Build and Smoke Test

`tools/phase3-build-and-smoke-test.sh` performs the Phase 3 build and validation. It:

1. requires a full Beacon commit SHA;
2. builds the image with the Hudson version and traceability metadata;
3. inspects and compares every required image label;
4. starts a temporary container with HTTPS bound only to `127.0.0.1:10443`;
5. waits for a successful HTTPS response; and
6. removes the smoke-test container on exit while retaining the built image.

The VPS build completed successfully. MeshCentral 1.2.5 responded over the loopback HTTPS endpoint, the requested labels matched the built image, the temporary container was removed, and no database or MeshCentral application port was left publicly listening.

## Build Observations

The inherited npm dependency installation reported three moderate-severity audit findings and deprecation notices for inherited packages. Phase 3 made no dependency changes because that would mix an upstream dependency/security update into the image-provenance phase. These findings must be evaluated through the planned dependency and security review before v1; no critical build failure was reported.

## Deferred Items and Phase 4 Handoff

- GitHub Actions/GHCR publication remains required before v1, but the project plan explicitly permits the initial image to be built locally or on the server.
- The image currently exists only in the VPS Docker image store; it is not a portable backup or registry artifact.
- Test and production Compose projects, persistent volumes, databases, secrets, TLS proxy configuration, administrator setup, and application backups belong to Phases 4 and 5.
- The current build is the slim upstream-default variant and does not preinstall a database client. Phase 4 must select the database and build variant before creating the persistent test environment.
- The stale local OpenSSH host-key entry created by the Phase 2 reinstall still requires trusted fingerprint reconciliation before routine administration; Phase 3 verification used the documented IP and key with an isolated host-key bypass.

None of these items prevents Phase 3 from closing. The Phase 3 exit criteria are satisfied: the image builds from Hudson's repository, launches successfully, and identifies the exact source commit used.

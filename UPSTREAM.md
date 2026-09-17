# Upstream MeshCentral

## Source

- Upstream repository: `https://github.com/Ylianst/MeshCentral.git`
- Upstream default branch: `master`
- Beacon Remote repository: `https://github.com/hudsonhelm/Beacon_Remote.git`
- Beacon visibility: private
- Beacon production/default branch: `master`
- Integration branch: `develop`
- Topic branches: `feature/<name>` and `hotfix/<name>`

## Baseline

- Upstream commit: `9f328938a355b778b037435dbc61ef89731f71ad`
- Upstream package version: `1.2.5`
- Upstream commit date: `2026-09-14T14:55:02+02:00`
- Beacon baseline tag: `beacon-upstream-1.2.5-20260914`

The baseline tag points directly to the unmodified upstream commit. Beacon bootstrap documentation is committed after that baseline.

## First Beacon Image

- Hudson image: `beacon-remote:0.1.0-hudson.1`
- Beacon source commit: `eb8869064d7771565368fecd7d578e657d3061d0`
- Upstream base commit: `9f328938a355b778b037435dbc61ef89731f71ad`
- Upstream package version: `1.2.5`

The first image was built locally on the Beacon VPS and records these revisions in OCI labels. The upstream `master` branch was nine commits ahead when Phase 3 was performed, but none changed the upstream Docker implementation. Those unrelated commits were not silently merged into the pinned baseline.

## Remote Configuration

```text
origin    https://github.com/hudsonhelm/Beacon_Remote.git
upstream  https://github.com/Ylianst/MeshCentral.git
```

Push only to `origin`. The local `upstream` push URL is intentionally disabled.

## Upstream Update Procedure

1. Fetch the official repository and its tags: `git fetch upstream --tags`.
2. Review upstream changes and release notes since the recorded baseline.
3. Create a feature branch from Beacon's current integration branch.
4. Merge the selected upstream `master` commit without rewriting upstream history.
5. Resolve conflicts narrowly and update this file with the new upstream commit and version.
6. Build the application/container and run upstream plus Beacon-specific tests.
7. Deploy the exact built image to staging and run the core remote-management regression checks.
8. Promote the same accepted image to production through a deliberate release tag.

Do not squash upstream history, force-push shared branches, deploy an unpinned `latest` image, or commit deployment secrets.

## License and Notices

MeshCentral is licensed under Apache License 2.0. The upstream `LICENSE` file and existing notices must remain present. Beacon changes must not remove or obscure upstream attribution or license requirements.

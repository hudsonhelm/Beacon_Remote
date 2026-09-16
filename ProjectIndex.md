# Beacon Remote Project Document Index

This index lists the documentation stored in the `Beacon_Remote` repository. Paths are relative to the repository root unless otherwise noted.

## Start Here

| Document | Location | Description |
|---|---|---|
| Project plan | [`docs/PROJECT_PLAN.md`](docs/PROJECT_PLAN.md) | Active project brief and source of truth for Beacon Remote. Defines the product direction, requirements, phased implementation plan, working conventions, and acceptance criteria. |
| Beacon changelog | [`CHANGELOG.md`](CHANGELOG.md) | Records Beacon-specific changes made on top of upstream MeshCentral. The `Unreleased` section summarizes completed project work that has not yet been assigned to a release. |
| Upstream record | [`UPSTREAM.md`](UPSTREAM.md) | Identifies the official MeshCentral source, pinned baseline, repository and branch model, upstream-update procedure, and license-preservation requirements. |

## Phase Records

| Document | Location | Description |
|---|---|---|
| Phase 0 — Repository Bootstrap | [`docs/PHASE_0.md`](docs/PHASE_0.md) | Records the repository, naming, branching, hierarchy, upstream-baseline, validation, and exit decisions completed during project bootstrap. |
| Phase 1 — Infrastructure Discovery and Environment Design | [`docs/PHASE_1.md`](docs/PHASE_1.md) | Records the verified OVHcloud inventory and the approved host, environment-isolation, DNS, TLS, port, backup, and Phase 2 handoff decisions. |

## Architecture Decision Records

| Document | Location | Description |
|---|---|---|
| ADR 0001 — Fixed MSP Hierarchy | [`docs/decisions/0001-msp-hierarchy.md`](docs/decisions/0001-msp-hierarchy.md) | Establishes the Customer → Site → Device hierarchy, explains how tags and MeshCentral device groups support it, and defines consequences and guardrails. |

## Upstream MeshCentral Documentation

These files are inherited from MeshCentral. They remain useful references, but they do not supersede the Beacon project plan or Beacon phase and decision records.

| Document | Location | Description |
|---|---|---|
| MeshCentral overview | [`readme.md`](readme.md) | Upstream product overview with links to official documentation, tutorials, community resources, issue reporting, and licensing information. |
| Documentation pointer | [`docs/README.md`](docs/README.md) | Points to the separately maintained upstream MeshCentral documentation repository. |
| Docker configuration guide | [`docker/README.md`](docker/README.md) | Upstream guide to MeshCentral container variants, persistence, environment variables, databases, and Docker deployment configuration. |
| RDP component notes | [`rdp/README.md`](rdp/README.md) | Describes the bundled `node-rdpjs` fork, Network Level Authentication support, and the GPL-3.0 licensing boundary for the `rdp` folder. |
| Translation guide | [`translate/readme.txt`](translate/readme.txt) | Explains how to edit MeshCentral translations and regenerate translated pages. |
| Security policy | [`SECURITY.md`](SECURITY.md) | Upstream supported-version and vulnerability-reporting information. |
| Community standards | [`CODE_OF_CONDUCT.md`](CODE_OF_CONDUCT.md) | Upstream conduct, collaboration, privacy, security, contribution, and enforcement expectations. |
| License | [`LICENSE`](LICENSE) | Apache License 2.0 terms that govern MeshCentral and must remain with the fork. |

## Supporting Reference Files

| Document | Location | Description |
|---|---|---|
| Dependency list | [`dependencies.txt`](dependencies.txt) | Compact reference list of the application's direct Node.js dependency versions. The authoritative install manifest remains `package.json` and `package-lock.json`. |
| Source package file list | [`SourceFileList.txt`](SourceFileList.txt) | Upstream inclusion patterns used when assembling a MeshCentral source package. |
| Email and SMS templates | [`emails/`](emails/) | Runtime message templates for account, device, support, invitation, reset, login, and SMS workflows; these are product content rather than project-governance records. |
| Public script-block reference | [`public/scriptblocks.txt`](public/scriptblocks.txt) | Runtime reference data used by MeshCentral's public web assets. |

## Reading Order

For project work, read `docs/PROJECT_PLAN.md` first, then the applicable phase record and architecture decision. Consult `CHANGELOG.md` for completed Beacon work and `UPSTREAM.md` before integrating a new MeshCentral baseline. Use the inherited MeshCentral documents only for the relevant upstream subsystem or procedure.


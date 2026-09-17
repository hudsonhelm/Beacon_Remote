# Beacon Remote Project Document Index

This index identifies the repository documents that matter, what each is for, and the recommended reading order. Paths are relative to the repository root.

## Project-Related Documents

Review these documents first when planning or performing Beacon Remote work.

| Document | Description |
|---|---|
| [`ProjectIndex.md`](ProjectIndex.md) | Master index of repository documentation, document purposes, and recommended reading order. |
| [`docs/PROJECT_PLAN.md`](docs/PROJECT_PLAN.md) | Active Beacon Remote project brief and source of truth. Version 11 defines the product vision, requirements, philosophy, implementation phases, development conventions, and acceptance criteria, including the hard Phase 3.5 Beacon Remote identity gate, completed traceable image build, MSP hierarchy, quick-support workflow, clipboard behavior, temporary UAC elevation, and unified endpoint experience. |
| [`docs/PHASE_0.md`](docs/PHASE_0.md) | Completed repository-bootstrap record covering Beacon naming, repository and branch structure, the upstream baseline, licensing, the Customer → Site → Device decision, validation, and the Phase 0 exit checklist. |
| [`docs/PHASE_1.md`](docs/PHASE_1.md) | Completed infrastructure-discovery and environment-design record covering the OVH VPS inventory, host design, test/production isolation, Ubuntu target, DNS/TLS/NGINX plan, backups, and the Phase 2 handoff. |
| [`docs/PHASE_2.md`](docs/PHASE_2.md) | Completed clean-rebuild and Docker-host baseline record covering Ubuntu 24.04, SSH administration, UFW, Docker/Compose, NGINX, Fail2ban, NTP, disk, backups, exposed ports, reboot validation, and accepted limitations. |
| [`docs/PHASE_3.md`](docs/PHASE_3.md) | Completed fork-image build record covering the Hudson image name and version, exact Beacon and upstream revisions, OCI traceability labels, reproducible build script, VPS build evidence, loopback HTTPS smoke test, and deferred registry automation. |
| [`docs/PHASE_3_5.md`](docs/PHASE_3_5.md) | Phase 3.5 implementation and acceptance record for the mandatory baseline Beacon Remote identity gate before persistent staging or production deployment. |
| [`docs/decisions/0001-msp-hierarchy.md`](docs/decisions/0001-msp-hierarchy.md) | Architecture Decision Record establishing Customer → Site → Device as the fixed operational hierarchy, with tags for cross-cutting organization. Records the rationale, rejected alternative, consequences, security guardrails, and MeshCentral mapping. |
| [`CHANGELOG.md`](CHANGELOG.md) | Beacon-specific changelog, separate from upstream history. Its current `Unreleased` section records work through Phase 3, the new Phase 3.5 identity gate, and notes that no functional MeshCentral customization has occurred yet. |
| [`UPSTREAM.md`](UPSTREAM.md) | Records the official MeshCentral source, pinned baseline and tag, first Beacon image provenance, Beacon branch model and remotes, upstream-update procedure, and license-preservation requirements. |

### Recommended Reading Order

1. Read `docs/PROJECT_PLAN.md` for current scope and governing rules.
2. Read the phase record relevant to the work.
3. Read applicable Architecture Decision Records under `docs/decisions/`.
4. Check `CHANGELOG.md` for completed Beacon work.
5. Consult `UPSTREAM.md` before integrating or comparing MeshCentral changes.

## Non-Project-Related Documents

These are inherited MeshCentral documentation, support references, packaging data, or repository workflow templates. **Do not review this list during ordinary project work unless the project-related documents do not contain what you need or the task directly concerns one of these areas.**

| Document | Description |
|---|---|
| [`readme.md`](readme.md) | Inherited MeshCentral overview with links to upstream documentation, tutorials, community resources, issue reporting, and licensing. It is not Beacon's project brief. |
| [`docs/README.md`](docs/README.md) | Small inherited pointer to MeshCentral's separately maintained documentation repository. |
| [`docker/README.md`](docker/README.md) | Inherited MeshCentral Docker guide covering image variants, persistence, environment variables, databases, and deployment configuration. |
| [`rdp/README.md`](rdp/README.md) | Technical notes for the bundled `node-rdpjs` fork, including NLA support and its GPL-3.0 licensing boundary. |
| [`translate/readme.txt`](translate/readme.txt) | Instructions for editing MeshCentral translations and regenerating translated pages. |
| [`SECURITY.md`](SECURITY.md) | Inherited supported-version and vulnerability-reporting policy. |
| [`CODE_OF_CONDUCT.md`](CODE_OF_CONDUCT.md) | Inherited community and contributor standards for conduct, collaboration, privacy, security, and enforcement. |
| [`LICENSE`](LICENSE) | Apache License 2.0 governing upstream MeshCentral and retained with the Beacon fork. |
| [`dependencies.txt`](dependencies.txt) | Compact direct-dependency version reference; `package.json` and `package-lock.json` remain authoritative. |
| [`SourceFileList.txt`](SourceFileList.txt) | Upstream file list and patterns used to assemble a MeshCentral source package. |
| [`public/scriptblocks.txt`](public/scriptblocks.txt) | Runtime reference data used by MeshCentral public web assets; it is not project documentation. |
| [`.github/ISSUE_TEMPLATE/bug_report.md`](.github/ISSUE_TEMPLATE/bug_report.md) | GitHub template for filing bug reports. |
| [`.github/ISSUE_TEMPLATE/feature_request.md`](.github/ISSUE_TEMPLATE/feature_request.md) | GitHub template for proposing features. |
| [`.github/PULL_REQUEST_TEMPLATE.md`](.github/PULL_REQUEST_TEMPLATE.md) | Contributor checklist and template presented when creating a pull request. |

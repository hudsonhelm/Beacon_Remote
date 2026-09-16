# Beacon / MeshCentral Fork — Project Bootstrap and v1 Plan

> **Document version:** 5
> **Last updated:** September 15, 2026
> **Status:** Active project brief / source of truth
>
> **Purpose:** This document is intended to be pasted or provided to the initial chat in a new Codex project. Treat it as the starting project brief and working source of truth until Nelson changes it.
>
> **Product name:** **Beacon**
> **Remote-management repository:** **`hudsonhelm/Beacon_Remote`**
> **Foundation:** MeshCentral fork
> **Primary goal:** Get a useful, live, self-hosted remote-management platform running immediately, then improve it incrementally based on real Hudson Helm support work.
>
> **Important philosophy:** Do not build a remote-control product from scratch. Start with working MeshCentral, preserve its useful capabilities, and make targeted changes only when there is a clear reason.

> **Current scope additions:** Temporary-session privilege elevation/UAC, true MSP hierarchy, reliable automatic clipboard, a polished six-digit quick-support workflow, and a unified managed-endpoint experience are explicit project requirements. Temporary-session elevation is a **v1 requirement**. The exact hierarchy model is a **Phase 0 design decision**.

## Document Version History

| Version | Date | Changes |
|---|---|---|
| **v1** | September 13, 2026 | Initial project plan covering fork creation, Docker deployment, test/production environments, real-world validation, branding, CI/CD, backup/restore, security review, and v1 acceptance. |
| **v2** | September 13, 2026 | Added temporary-session UAC/elevation, Phase 0 hierarchy decision, clipboard reliability, six-digit quick-support workflow, and unified MeshAgent/Assistant endpoint experience as explicit project requirements. |
| **v3** | September 13, 2026 | Added the **“Engage”** authorization convention allowing Codex to document, implement, commit locally, and push the current approved scope to GitHub without further approval unless a blocker or material scope issue is encountered. |
| **v4** | September 15, 2026 | Adopted **Beacon** as the product and repository name and recorded the Phase 0 fixed Customer → Site → Device hierarchy decision. |
| **v5** | September 15, 2026 | Separated the Beacon product-family name from the remote-management module and renamed its repository to `Beacon_Remote`; established the `Beacon_<Module>` repository naming convention. |

---

## 1. Product Vision

Beacon begins as a customized fork of MeshCentral for Hudson Helm's own day-to-day MSP use.

Beacon is the product-family name. This MeshCentral-based remote-management module is maintained in `hudsonhelm/Beacon_Remote`. Future module repositories should use the `Beacon_<Module>` convention so their relationship to the Beacon product line is explicit without treating this repository as the entire product family.

The long-term idea is broader than remote control: one persistent, self-updating endpoint agent that can eventually expose separately licensed or enabled capabilities without requiring administrators to replace the agent every time a new feature is added.

Possible future capabilities include:

- Remote desktop/control
- Unattended access
- One-time/interactive support sessions
- Chat
- Clipboard synchronization
- File management
- Remote terminal / PowerShell
- Basic system inventory
- Scripting
- Monitoring
- Patch-management integration or native patching
- Additional MSP-oriented modules

**Do not build the future roadmap now.** The immediate objective is a useful v1 based on MeshCentral.

The product is being built **for Hudson Helm first**. Real daily use will determine priorities.

---

## 2. Core Product Principles

1. **Working software on day one.**
   We should have a functional MeshCentral-based environment before significant customization begins.

2. **Fork from day one.**
   Even the nearly-stock initial deployment should come from our repository/branch and our build process, not from an unrelated stock install that must later be converted.

3. **Preserve useful MeshCentral functionality.**
   Do not remove terminal, files, inventory, management features, or other existing capabilities merely to make the first release resemble HelpWire.

4. **Change what hurts first.**
   The backlog should be driven primarily by problems encountered during real support work.

5. **Minimize divergence from upstream.**
   Prefer configuration, branding hooks, modular additions, and small isolated changes over broad rewrites.

6. **Upstream updates must remain practical.**
   Every customization should be evaluated partly on how difficult it will make future upstream merges.

7. **Windows first.**
   Hudson Helm's practical need is Windows. Do not spend project time polishing macOS support. Existing upstream cross-platform code should not be gratuitously broken, but macOS is not a project requirement.

8. **Docker first.**
   Both test and production should run as Docker-based deployments. A prebuilt VM/virtual appliance may be explored later.

9. **Security is not optional.**
   This is remote-access software. Authentication, MFA, TLS, secrets management, auditability, safe updates, and rollback matter from the beginning.

10. **Avoid premature commercialization work.**
    Billing, paid licensing, entitlement servers, SaaS onboarding, reseller programs, and appliance licensing are future work. v1 is primarily for Hudson Helm's own use.

11. **One endpoint product, even if multiple processes exist internally.**
    The managed endpoint should present itself as one Hudson product: one installer, one product identity, one tray experience, and one update strategy. MeshAgent and Assistant functionality may remain separate internal processes if combining them into one executable would create unnecessary complexity.

12. **Quick support must feel like a modern support product.**
    The target is not merely “MeshCentral invitation codes work.” The user experience should become: open support site, enter a short code, run a small client, approve access, and connect.

13. **Temporary-session elevation is not optional for v1.**
    The temporary support workflow must support privilege elevation/UAC in a practical MSP support scenario.

14. **Clipboard reliability is a product-quality issue.**
    Automatic bidirectional text clipboard should be reliable. Manual clipboard transfer may remain available as a fallback, but it is not the desired primary workflow.

---

## 3. v1 Definition

A satisfactory v1 does **not** need to be a ground-up rewrite or a completely independent product.

A v1 is reached when:

- The service is running reliably in production.
- A separate live test/staging environment exists.
- Both environments deploy from Hudson Helm's fork.
- The production instance is usable for real Hudson Helm support work.
- Remote desktop/control is dependable.
- Unattended agents reconnect reliably after reboot.
- Terminal and file-management functions work acceptably.
- Clipboard behavior is acceptable.
- Temporary-session privilege elevation/UAC works in the approved v1 workflow.
- Required administrator/elevation workflows have been tested and documented.
- Automatic bidirectional text clipboard is reliable enough for routine support use, with a manual fallback available.
- A quick-support workflow exists that uses a short-lived, one-time support code and does not require the customer to understand MeshCentral device-group enrollment.
- Managed endpoints present a unified Beacon user experience even if MeshAgent and Assistant remain separate internal processes.
- Device grouping/organization is usable for MSP work.
- The UI/branding is recognizably Beacon rather than a completely stock deployment.
- High-impact pain points discovered through actual use have been corrected or consciously accepted.
- Backups and restore procedures are tested.
- Updates can be tested in staging and promoted to production predictably.
- Rollback is documented and tested.
- No secrets are committed to Git.
- Admin MFA is enabled.
- Production is stable enough that Nelson is comfortable depending on it for routine support.

**Codex must not declare v1 complete merely because a checklist mechanically passes. Nelson makes the final v1 acceptance decision.**

---

## 4. Explicit Non-Goals for v1

Unless Nelson later changes scope, do not make these prerequisites for v1:

- Native macOS-focused work
- New remote-desktop transport protocol
- Replacing MeshCentral's entire web UI
- A completely new endpoint agent
- Commercial licensing server
- Subscription billing
- Public SaaS signup
- White-label/reseller support
- Virtual appliance / OVA / VHDX distribution
- Native patch-management engine
- Full RMM monitoring platform
- Mobile applications
- Multi-region infrastructure
- High-availability clustering
- Massive-scale optimization

These may become later projects.

---

# PHASES

## Phase 0 — Project and Repository Bootstrap

### Goal
Create a clean Beacon fork that can continue receiving upstream MeshCentral changes.

### Tasks

- Fork the official MeshCentral repository into the Hudson Helm-controlled GitHub account/organization.
- Inspect the upstream repository before choosing branch names. Do **not** assume `main` or `master`; use the actual current upstream default branch.
- Add the official MeshCentral repository as the `upstream` remote.
- Establish a simple branch model:
  - production/default branch for Hudson's releasable code
  - `develop` for integrated work if useful
  - `feature/<name>` branches for individual changes
  - `hotfix/<name>` for urgent production fixes
- Preserve upstream history.
- Do not squash or rewrite upstream history simply to make the fork look cleaner.
- Create a baseline tag identifying the exact upstream commit used for the initial deployment.
- Record the upstream commit SHA in deployment/release metadata.
- Add this project brief to the repository, likely under `docs/PROJECT_PLAN.md`.
- Add a `CHANGELOG.md` for Hudson-specific changes.
- Add a short `UPSTREAM.md` describing:
  - upstream repository
  - upstream branch
  - last upstream commit merged
  - merge/update procedure
- Confirm MeshCentral's Apache-2.0 license remains present and required notices are preserved.

### Phase 0 Product-Model Decision — MSP Hierarchy

**Decision recorded September 15, 2026:** Use the fixed **Customer → Site → Device** hierarchy with tags for cross-cutting organization. See `docs/decisions/0001-msp-hierarchy.md` for the rationale and guardrails.

Before building Hudson-specific data structures or UI, decide the hierarchy model.

Evaluate at least these two models:

**Option A — Fixed MSP hierarchy**
- Customer
  - Site
    - Device
- Additional organization through tags/folders where useful.

**Option B — Arbitrary nesting**
- Customer
  - Region
    - Site
      - Department
        - Device
- Arbitrary folder depth beneath the customer.

The decision must consider:

- daily usability for a small MSP
- permissions
- search/navigation
- licensing/reporting implications
- future monitoring and policy inheritance
- migration complexity
- whether MeshCentral's existing device-group model can be reused or should sit underneath a Hudson organizational layer

Do not silently default to either model. Record the selected hierarchy and rationale in the repository before related implementation begins.

### Exit Criteria

- Hudson-controlled fork exists.
- Upstream remote is configured.
- Baseline commit/tag is recorded.
- No functional customizations are required yet.
- Repository can be cloned and built.

---

## Phase 1 — Infrastructure Discovery and Environment Design

### Goal
Determine exactly where the first live deployments will run.

### Known Facts

Nelson believes he already pays for a small cloud server that has barely or never been used. Provider and specifications will be supplied later.

### Gather

- Cloud provider
- VM size:
  - vCPU
  - RAM
  - disk size/type
  - bandwidth allowance
- Operating system and version
- Public IPv4/IPv6
- Firewall/security-group configuration
- Existing services on the VM
- Provider snapshot/backup capability
- Root/sudo access method
- Whether SSH key authentication is already configured

### Initial Environment Names

Preferred starting hostnames:

- **Production:** `remote.hudsonhelm.com`
- **Test/Staging:** `remote-test.hudsonhelm.com`

These are working names. Nelson may rename them.

### Deployment Layout

Prefer Docker/Compose.

If the server has enough capacity, test and production may initially share the same VM while remaining isolated through:

- separate containers
- separate Docker Compose projects
- separate volumes
- separate databases
- separate configuration
- separate hostnames
- separate secrets

If resources are insufficient, use separate VMs.

**Never allow the test environment to use production data or production credentials.**

### DNS

Hudson Helm uses Cloudflare for DNS.

For the first deployment, prefer the least surprising networking configuration. Do not enable Cloudflare proxying merely because it is available. MeshCentral uses long-lived connections/WebSockets and agent connectivity; validate proxy behavior explicitly before placing Cloudflare or another reverse proxy in the traffic path.

### Exit Criteria

- Hosting location known.
- Test/prod topology chosen.
- DNS plan chosen.
- Required ports identified.
- Backup approach identified.

---

## Phase 2 — Server Baseline and Docker Host Preparation

### Goal
Prepare a clean, maintainable Docker host.

### Tasks

- Fully patch the host OS.
- Configure SSH securely.
- Prefer SSH keys over password-only administration.
- Create a non-root administrative account where appropriate.
- Configure host firewall/security groups.
- Install:
  - Docker Engine
  - Docker Compose plugin
  - Git
  - basic troubleshooting utilities
- Enable Docker/container restart on host reboot.
- Configure system time/NTP.
- Confirm adequate disk space.
- Configure basic host backup/snapshot procedure.
- Decide whether a reverse proxy is necessary.
- Do not expose databases directly to the public Internet.

### Security Baseline

- Only expose ports required for MeshCentral and administration.
- Restrict SSH source IPs when practical.
- Do not store secrets in the repository.
- Use `.env`/secret files with restrictive permissions or an appropriate secrets mechanism.
- Document all externally exposed ports and why they exist.

### Exit Criteria

- Docker host survives reboot and returns healthy.
- Docker Compose works.
- Host firewall is documented.
- Snapshot/backup is available before application deployment.

---

## Phase 3 — Build Beacon From Our Fork

### Goal
The first deployed copy must come from Hudson's fork.

### Important Rule

Do **not** simply deploy `ghcr.io/ylianst/meshcentral:latest` as the long-term application and call it Beacon.

It is acceptable to use upstream images briefly as a reference/troubleshooting comparison, but our live Hudson environments should ultimately build from our fork.

### Tasks

- Inspect the official MeshCentral Docker implementation in the current upstream repository.
- Reuse upstream Docker work wherever sensible rather than creating an unrelated packaging system.
- Build an image from the Hudson fork.
- Give the image a Hudson-controlled name.
- Initially, local/server builds are acceptable.
- Before v1, automate image builds in GitHub Actions and publish them to a Hudson-controlled registry, likely GitHub Container Registry (GHCR).
- Pin deployments to a specific Hudson image tag or immutable digest.
- Never deploy production using an unpinned `latest` image.

### Suggested Versioning

Use a Hudson-specific release sequence that makes the upstream base traceable.

Example concept:

`0.1.0-hudson.1`

Release metadata should include:

- Hudson version
- Git commit SHA
- upstream MeshCentral base commit/version
- build date

Exact version format can be adjusted before first release.

### Exit Criteria

- Docker image builds successfully from Hudson's repository.
- Image launches successfully.
- Exact source commit used by the running image is identifiable.

---

## Phase 4 — Live Test/Staging Environment

### Goal
Bring up a persistent environment where changes can be safely tested before production.

### Requirements

- Dedicated hostname
- Dedicated configuration
- Dedicated persistent volumes
- Dedicated database
- Dedicated admin credentials
- TLS
- MFA for administrative account
- New public account creation disabled after initial setup unless deliberately required
- Backups
- Logging

### Initial Functional Check

From at least two Windows machines:

- Log into the operator console.
- Create a device group.
- Install a persistent agent.
- Confirm agent comes online.
- Start remote desktop.
- Use terminal.
- Use file management.
- Test automatic clipboard in both directions.
- Test manual clipboard fallback.
- Test current invitation-code / Assistant quick-support behavior as a baseline.
- Test current temporary-session UAC/elevation behavior and document the exact limitation before modifying it.
- Reboot endpoint.
- Confirm agent reconnects.
- Confirm remote access after reboot.

### Exit Criteria

- Test environment is live at its own hostname.
- At least one Windows endpoint is enrolled.
- Core management functions work.
- Endpoint survives reboot/reconnect.

---

## Phase 5 — Live Production Environment

### Goal
Deploy a clean production instance from the same Hudson fork/build system.

### Requirements

Production must use its own:

- hostname
- configuration
- database
- volumes
- admin credentials
- TLS assets
- secrets
- backup set

### Production Hardening

- Strong unique administrator credentials
- MFA enabled
- Public self-registration disabled unless explicitly needed
- Review MeshCentral domain/user permissions
- Review remote-session consent configuration
- Review event/audit retention
- Review terminal/file permissions
- Confirm externally exposed ports
- Confirm backups are actually restorable
- Confirm production image is pinned to a release/version
- Document emergency rollback

### Exit Criteria

- Production is live.
- Production is built from Hudson's fork.
- Nelson can enroll a Windows test computer.
- Nelson can successfully operate the endpoint remotely.

At this point, Beacon is already a usable product even if visual customization is minimal.

---

## Phase 6 — Baseline Real-World Validation

### Goal
Learn what MeshCentral actually does well and what needs changing before guessing at a roadmap.

### Test Matrix

Perform and document:

#### Remote Desktop
- Same-LAN connection
- Internet/NAT connection
- Different ISP/network
- High latency
- poor Wi-Fi / cellular hotspot if practical
- multi-monitor
- resolution changes
- lock screen
- Windows login screen
- disconnect/reconnect
- long session
- rapid reconnect
- operator browser refresh/reconnect

#### Privilege / UAC
- Standard-user desktop
- Administrator desktop
- UAC prompt behavior
- unattended service workflow
- one-time/interactive support workflow
- temporary-session elevation when the logged-in user is not an administrator
- technician-assisted elevation where the technician has appropriate administrator credentials
- session continuity/reconnection after elevation

**v1 target:** The temporary client must support a practical “Request Administrator Access” workflow. The intended user experience is:

1. Customer runs the temporary Beacon client without requiring permanent installation.
2. Technician establishes the support session.
3. Technician requests administrator access.
4. Windows performs the required UAC/credential step.
5. The support component elevates or starts the required temporary service/process.
6. The technician's session resumes/reconnects without forcing the customer to start over.

The exact implementation may use separate temporary processes/services internally. The requirement is the resulting support workflow, not a particular process layout.

#### Endpoint Lifecycle
- install agent
- reboot
- shutdown/startup
- user logoff/logon
- network loss
- server restart
- Docker restart
- host reboot
- endpoint offline for an extended period, then reconnect

#### Built-In Tools
- terminal
- PowerShell
- file browsing
- upload/download
- automatic bidirectional text clipboard
- manual clipboard fallback
- repeated copy/paste across long sessions
- clipboard recovery after disconnect/reconnect
- basic system information
- chat/messaging where applicable

#### Performance
Record rough observations for:
- CPU use on endpoint
- memory use
- bandwidth during remote session
- perceived latency
- video/full-motion performance
- server CPU/memory during sessions

### Pain-Point Log

Create a living backlog with:

- description
- severity
- frequency
- workaround
- proposed fix
- affected upstream component
- whether fix requires source modification

Prioritize by:

1. blocks real work
2. occurs frequently
3. creates user/customer confusion
4. wastes technician time
5. visual/branding annoyance

### Exit Criteria

- We have used the live system enough to identify real pain points.
- The backlog is based on experience, not feature speculation.

---

## Phase 7 — Minimum Branding and Product Identity

### Goal
Make the deployment recognizably Beacon without creating a maintenance nightmare.

### Likely Changes

- Product title
- Beacon name
- Hudson Helm logo/branding
- favicon
- login-page identity
- basic terminology
- support/contact links
- installer/download naming where practical
- endpoint-facing prompts where appropriate
- operator-facing title/version information

### Rules

- Use existing MeshCentral branding/configuration capabilities first.
- Source changes should be made only where configuration cannot reasonably accomplish the requirement.
- Keep a clear record of every Hudson-specific source customization.
- Avoid large visual rewrites before daily use proves they are worthwhile.

### Exit Criteria

- An operator/customer can clearly tell this is Beacon.
- Branding changes survive rebuild/redeploy.
- Upstream merge difficulty remains low.

---

## Phase 8 — Core Beacon Workflow Changes Required for v1

### Goal
Close the specific gaps between stock MeshCentral and the Beacon support experience.

These items are now **planned v1 work**, not merely optional future ideas.

### 8.1 Temporary-Session Privilege Elevation / UAC

Implement and validate the temporary-session elevation workflow defined in Phase 6.

Requirements:

- must work from a non-installed/temporary support client
- customer should not need to understand Windows services or manually restart the support app
- support session should reconnect automatically or with minimal operator action after elevation
- must support the normal UAC approval path
- should support technician-entered administrator credentials when appropriate and technically safe
- must not weaken Windows security controls
- must not store reusable admin credentials in the temporary client
- elevation actions should be auditable
- failed/cancelled elevation must return the user to a safe non-elevated support state

### 8.2 True Customer / Site / Device Hierarchy

Implement the hierarchy model selected in Phase 0.

Requirements:

- hierarchy must be first-class in the operator experience
- devices must belong to a real customer context
- site/location organization must be represented according to the selected model
- search should work across customer/site/device names
- permissions and future policy inheritance should not be made harder by the data model
- do not permanently fake this solely through naming conventions if a proper Hudson data model is required
- preserve compatibility with MeshCentral's underlying device/group model where practical

### 8.3 Clipboard Reliability

Treat automatic clipboard as a v1 quality target.

Requirements:

- automatic text copy/paste in both directions
- repeated use during the same session
- recovery after temporary disconnect/reconnect
- reasonable behavior across common browsers/operator platforms used by Hudson Helm
- retain a manual clipboard mechanism as fallback
- reproduce and document any upstream clipboard defect before patching it
- if Hudson fixes an upstream bug, keep the patch isolated and suitable for upstream contribution where practical

### 8.4 Six-Digit Quick-Support Workflow

Build a cleaner support-session flow on top of MeshCentral's invitation/session mechanisms.

Target customer experience:

```text
support.hudsonhelm.com
        |
        v
Enter 6-digit support code
        |
        v
Download / run Beacon support client
        |
        v
Client automatically associates with the correct support session
        |
        v
Customer approves
        |
        v
Technician connects
```

Requirements:

- short-lived code
- one-time-use or single-session semantics
- code must not be a permanent device-group enrollment credential
- no requirement for the customer to select an organization/device group
- code generation must be easy for the technician
- invalid/expired codes must fail clearly
- codes must be sufficiently protected against guessing/brute force
- temporary-session logging/audit record
- use existing MeshCentral invitation mechanisms where possible rather than reinventing transport/session plumbing

### 8.5 Unified Managed Endpoint Experience

For a managed endpoint, the user/admin should perceive **one Beacon product**.

Target:

```text
Beacon
├── background service / MeshAgent functionality
├── tray/user interaction / Assistant functionality
├── unattended access
├── user notifications
├── chat / support request UX
├── update status
└── future capabilities
```

Requirements:

- one installation workflow
- one product name
- one tray identity
- one normal uninstall experience
- coordinated updating
- no requirement for the sysadmin to manually deploy a second visible product merely to gain tray/user-interaction functionality
- if MeshAgent and Assistant remain separate executables/processes internally, installation and lifecycle management must hide that complexity from the customer
- avoid combining binaries solely for aesthetic reasons if doing so makes maintenance or upstream merging significantly harder

### Exit Criteria

- Temporary-session elevation works in the agreed workflow.
- Hierarchy implementation matches the recorded Phase 0 decision.
- Automatic clipboard is reliable enough for routine support.
- Quick-support six-digit flow works end to end.
- Managed endpoint presents a unified Beacon experience.
- All five areas have regression tests or documented manual acceptance tests as appropriate.

---

## Phase 9 — Highest-Impact Workflow Improvements

### Goal
Iteratively customize the system based on Nelson's actual support workflow.

There is intentionally **no fixed feature list** for this phase.

For every proposed change:

1. Describe the real pain point.
2. Confirm it exists in the current build.
3. Search upstream configuration/docs/issues before modifying core code.
4. Decide whether it can be solved by:
   - configuration
   - theme/branding override
   - small isolated patch
   - plugin/module
   - larger source change
5. Implement in a feature branch.
6. Add tests where practical.
7. Deploy to test.
8. Use it.
9. Promote to production only after acceptance.

### Examples of Potential Improvements

These are possibilities, not automatic requirements:

- Better device/group navigation
- Better nested MSP/customer organization
- Cleaner operator landing screen
- Faster connection workflow
- Simplified endpoint enrollment
- Improved one-time support workflow
- Better admin/elevation flow
- Better device summaries
- More useful system information at a glance
- Improved search
- Better online/offline indicators
- Better customer-facing prompts
- Cleaner chat UX
- Installer simplification
- System tray experience
- Additional audit visibility

### Important

Do not remove existing useful functions simply because they make the software broader than HelpWire. If terminal, files, inventory, or management capabilities are useful, keep them.

---

## Phase 10 — CI/CD and Release Discipline

### Goal
Make upgrades boring and repeatable before calling the product v1.

### GitHub Actions

Create workflows for:

#### Pull Request / Branch Validation
- install dependencies
- lint where supported
- run upstream tests
- run Hudson-specific tests
- build application/container
- fail clearly on errors

#### Test Environment Build
On approved integration branch/tag:
- build Docker image
- tag with commit SHA
- publish to GHCR
- deploy or provide controlled deployment command for test

#### Production Release
Production promotion should require deliberate action.

Preferred sequence:

`feature -> test -> accepted release tag -> production`

Never auto-deploy arbitrary commits directly to production.

### Release Record

Every production release should record:

- Hudson version/tag
- commit SHA
- upstream base version/commit
- notable changes
- database/config changes
- backup taken
- rollback target

### Exit Criteria

- A fresh build can be reproduced.
- Test deployment is repeatable.
- Production promotion is controlled.
- Rollback target is always known.

---

## Phase 11 — Backup, Restore, and Rollback Validation

### Goal
Prove recovery instead of merely claiming backups exist.

### Back Up

At minimum:

- MeshCentral configuration/data
- database
- uploaded/files area if used
- certificates/keys required by the deployment
- Compose files
- deployment configuration
- secrets through a secure method separate from Git
- any Hudson-specific persistent state

### Perform a Restore Test

Restore into an isolated environment and verify:

- service starts
- administrator login works
- devices/groups/users are present
- agents can reconnect where appropriate
- no production system is accidentally affected

### Container Rollback

Document:

1. current image
2. prior known-good image
3. backup/snapshot point
4. rollback command/process
5. conditions that require database rollback

### Exit Criteria

- At least one successful restore has been performed.
- At least one application-version rollback has been rehearsed.

---

## Phase 12 — Security Review Before v1

### Goal
Review the deployment as remote-access infrastructure, not an ordinary website.

### Review

- TLS configuration
- exposed ports
- SSH access
- admin MFA
- account creation
- password policy
- session timeout
- agent authentication
- server certificates
- reverse proxy trust configuration, if used
- file/terminal permissions
- audit/event logging
- secrets storage
- database exposure
- backup protection
- Docker permissions
- dependency vulnerabilities
- image provenance
- upgrade process
- endpoint uninstall/revocation process

### Code / Dependency Review

- Identify all Hudson source modifications.
- Confirm Apache-2.0 obligations/notices are retained.
- Run dependency/security scanning.
- Do not introduce custom cryptography.
- Do not weaken MeshCentral authentication/security mechanisms merely to simplify UX.

### Exit Criteria

- No known critical security issue remains unaddressed.
- Risks accepted for v1 are explicitly documented.

---

## Phase 13 — v1 Release Candidate and Live Acceptance

### Goal
Use the release candidate in real Hudson Helm work until it is trusted.

### Procedure

1. Tag an RC build.
2. Deploy it to test.
3. Complete regression testing.
4. Promote the same exact image to production.
5. Use production for actual support work.
6. Record bugs/pain points.
7. Fix blockers and serious workflow problems.
8. Repeat RC cycle as needed.

### Suggested Acceptance Evidence

These are guidelines, not rigid contractual numbers:

- Multiple real-world remote sessions
- Multiple unattended reconnects/reboots
- Successful terminal/file usage
- Successful automatic clipboard use across multiple sessions
- Successful six-digit temporary support sessions
- Successful temporary-session privilege elevation/UAC
- Successful managed-agent + tray/user UX behavior
- Successful navigation using the chosen Customer/Site/Device hierarchy
- Successful sessions from outside the Hudson Helm network
- At least one server/container restart without lasting disruption
- Successful backup/restore test
- Successful rollback rehearsal
- No unresolved issue that Nelson considers a blocker for routine use

### v1 Completion

Nelson explicitly approves v1.

Then:

- Create final v1 tag/release.
- Publish the production container image.
- Update `CHANGELOG.md`.
- Update `UPSTREAM.md`.
- Record deployment version in production.
- Archive release notes.
- Keep test environment running for future work.

---

# 5. Test and Production Promotion Model

The intended lifecycle is:

```text
Upstream MeshCentral
        |
        v
Hudson Fork
        |
        v
feature branch
        |
        v
PR / automated tests
        |
        v
Hudson integration branch
        |
        v
Docker image tagged by SHA
        |
        v
LIVE TEST ENVIRONMENT
        |
        | Nelson tests / accepts
        v
Release tag
        |
        v
LIVE PRODUCTION ENVIRONMENT
```

The same built image that passes staging should be promoted to production whenever practical. Do not rebuild different source for production.

---

# 6. Environment Isolation

## Test

Example:

- `remote-test.hudsonhelm.com`
- test database
- test volumes
- test secrets
- test endpoint group
- non-production admin credentials

## Production

Example:

- `remote.hudsonhelm.com`
- production database
- production volumes
- production secrets
- production backups
- production administrator/MFA

### Never

- Share a database between test and production.
- Mount production volumes into test.
- Put production secrets in test.
- Test destructive migrations directly in production.
- Point experimental agents at production unless deliberately testing a production behavior.

---

# 7. Database Guidance

MeshCentral supports multiple database options and the current official Docker Compose example includes MongoDB.

For this project:

- Inspect current upstream recommendations before final selection.
- Prefer using a production-suitable external database container from the start rather than depending on an embedded store and migrating later.
- Keep test and production databases separate.
- Never expose the DB port publicly.
- Pin database container versions before production.
- Include database backup and restore in the v1 recovery test.

Do not blindly use `mongo:latest` in production.

---

# 8. Docker Guidance

- Prefer Docker Compose for initial deployment.
- Pin image versions.
- Persistent data must live outside ephemeral containers.
- Containers must restart automatically after host reboot.
- Test and production must be distinct Compose projects.
- Keep deployment manifests in Git.
- Keep secrets out of Git.
- Do not make manual changes inside running containers and depend on them persisting.
- Every production customization should be reproducible from Git + secure secrets + persistent data backup.

---

# 9. Upstream Merge Strategy

MeshCentral is an active upstream project. We want its fixes.

For each upstream update:

1. Read upstream release notes/changes.
2. Merge/rebase according to the documented project policy.
3. Resolve conflicts carefully.
4. Record new upstream base commit/version.
5. Build a new Hudson test image.
6. Run automated tests.
7. Deploy to the test environment.
8. Run core remote regression tests.
9. Promote only after acceptance.

If a Hudson customization repeatedly causes merge conflicts, consider redesigning that customization to reduce coupling with upstream.

---

# 10. Future Architecture Notes — Do Not Implement Yet

## One Agent / Multiple Capabilities

The long-term product concept is one installed Hudson agent rather than separate products/agents for each feature.

Conceptually:

```text
Hudson Agent
├── Core identity
├── Secure server connection
├── Self update
├── Remote
├── Files
├── Terminal
├── Inventory
├── Scripting            [future]
├── Monitoring           [future]
└── Patching             [future]
```

MeshCentral already provides several of these capabilities. Preserve that advantage.

## Self-Updating

Long term, endpoint-agent updates must be centrally manageable and safe.

Desired eventual characteristics:

- signed updates
- staged rollout
- test ring
- production ring
- rollback
- version visibility
- no manual touch required on hundreds of endpoints

Do not design a future system that requires technicians to manually update every installed agent.

## Licensing

Commercial licensing is explicitly **not a v1 requirement**.

If Beacon later becomes a paid self-hosted product, the intended philosophy is:

- licensing server periodically refreshes signed entitlements
- reasonable offline/full-function grace period
- after expiration, a further limited-function emergency period remains available
- conspicuous red warnings during expired/limited mode
- core emergency remote access should not disappear instantly because of a billing/licensing outage
- the product should avoid stranding an MSP during a customer emergency

Exact timing and entitlement enforcement are future design work.

## Cloud Hosting / Appliance

Initial delivery:

- Hudson-hosted Docker environment

Possible future options:

- customer self-hosted Docker Compose
- prebuilt virtual appliance
  - VMware OVA/OVF
  - Hyper-V VHDX
  - possibly Proxmox-friendly image
- cloud marketplace image

Do not build appliance packaging before the Docker product is stable.

---

# 11. Development Rules for Codex

These rules matter.

## “Engage” Authorization Keyword

During this project, when Nelson says **“Engage”**, that constitutes explicit approval for Codex to proceed with the **current step, phase, or requested change** through completion.

For the approved scope, Codex is authorized to:

- make the required code/configuration/documentation changes
- update relevant project documentation
- run appropriate tests and validation
- create local commits
- push the approved work to the Hudson-controlled GitHub repository

No additional confirmation is required for those actions within the approved scope.

Codex must stop and ask for guidance only if it encounters a material blocker, an ambiguity that could change the intended outcome, a destructive or irreversible action outside the already-approved scope, or a need to expand the scope beyond what Nelson approved.

“Engage” is **not** blanket approval for unrelated future work, additional phases, or scope expansion. It applies to the current step, phase, or change being discussed when the command is given.

1. **Read before changing.** Understand the relevant upstream code path first.
2. **Do not rewrite working subsystems casually.**
3. **Prefer existing MeshCentral configuration/hooks over source modifications.**
4. **Keep Hudson changes small and isolated when possible.**
5. **Do not remove upstream functionality unless Nelson explicitly requests it.**
6. **Do not make macOS support a project priority.**
7. **Do not introduce new frameworks/libraries without a reason.**
8. **Do not commit secrets.**
9. **Do not change production directly.**
10. **Every significant change goes through test first.**
11. **Add or update tests for Hudson changes where practical.**
12. **Preserve upstream license notices.**
13. **Document deployment-impacting changes.**
14. **If a requirement is ambiguous, ask rather than inventing a major product decision.**
15. **Do not begin future-roadmap features merely because they appear in this document.**
16. **Optimize for maintainability and upstream mergeability, not maximum customization.**
17. **Do not claim a feature is tested unless it was actually tested.**
18. **When a live/manual test is required, give Nelson concise exact steps and wait for the result.**
19. **Keep the project usable throughout development.**
20. **The live product is not a throwaway prototype. Treat production data and remote-access security accordingly.**

---

# 12. First Codex Session Checklist

When this document is first provided to Codex, begin with these steps:

- [ ] Inspect the repository and current upstream state.
- [ ] Confirm the exact upstream repository URL and default branch.
- [ ] Confirm current license.
- [ ] Record current upstream commit/version.
- [ ] Inspect upstream Docker files and official deployment guidance.
- [ ] Do not modify code yet unless necessary for bootstrap.
- [ ] Ask Nelson for the cloud VM provider/specifications when not yet supplied.
- [ ] Ask for the chosen GitHub organization/repository name if not apparent.
- [ ] Confirm production and test DNS names.
- [ ] Make and record the Phase 0 hierarchy decision: fixed Customer → Site → Device plus tags/folders, or arbitrary nesting.
- [ ] Establish baseline behavior for temporary-session elevation/UAC, automatic clipboard, invitations/codes, and MeshAgent + Assistant integration before modifying them.
- [ ] Produce the exact Phase 0/1 implementation steps based on the actual repository and server.
- [ ] Keep Phase 0 changes minimal.
- [ ] Get the live test instance working from Hudson's fork.
- [ ] Then get the production instance working.
- [ ] Only after the baseline is proven, begin customization.

---

# 13. Open Decisions / Information Still Needed

These are intentionally unresolved.

- Cloud provider
- VM specifications
- Host operating system
- Whether one VM can comfortably host both test and production initially
- Final production hostname
- Final test hostname
- Database choice/version
- Reverse proxy choice, if any
- Backup destination
- Email/SMTP requirements
- First branding assets
- Exact implementation of temporary-session UAC/elevation
- Whether the first one-time support workflow will use MeshCentral Assistant or another upstream mechanism
- Exact server-side/session-code mechanism for the six-digit support flow
- Whether any agent binary rebranding is required before v1
- How MeshAgent and Assistant lifecycle/update behavior will be presented as one Beacon installation

Do not guess silently on infrastructure/security decisions that depend on these answers.

---

# 14. Current Working Assumptions

Until Nelson changes them:

- Product name: **Beacon**
- Remote-management repository: **`hudsonhelm/Beacon_Remote`**
- Future module repositories use the **`Beacon_<Module>`** naming convention.
- Parent/business: **Hudson Helm**
- Windows is the priority platform.
- Docker is the deployment standard.
- MeshCentral is the upstream foundation.
- The fork starts as close to upstream as possible.
- Existing useful features stay.
- Real-world use determines customization order except for explicit v1 requirements listed in this document.
- Temporary-session privilege elevation/UAC is a v1 requirement.
- Reliable automatic clipboard is a v1 requirement.
- A six-digit quick-support workflow is a v1 requirement.
- Managed endpoints should present MeshAgent + Assistant-style functionality as one Beacon product experience.
- Production and test are both persistent/live environments.
- Commercial licensing is later.
- Virtual appliance packaging is later.
- v1 should be reached in weeks rather than by attempting a ground-up rewrite over months.

---

# 15. Official Upstream References

Codex should verify current information from upstream rather than relying on stale assumptions.

- MeshCentral repository: https://github.com/Ylianst/MeshCentral
- MeshCentral documentation: https://docs.meshcentral.com/
- Upstream Docker Compose example: https://github.com/Ylianst/MeshCentral/blob/master/docker/compose.yaml
- Upstream Docker configuration template: https://github.com/Ylianst/MeshCentral/blob/master/docker/config.json.template
- MeshCentral configuration schema: https://github.com/Ylianst/MeshCentral/blob/master/meshcentral-config-schema.json

At the time this project plan was prepared, the upstream repository identifies MeshCentral as Apache-2.0 licensed and includes official Docker packaging. Verify this again during Phase 0.

---

## Final Direction to Codex

The most important idea in this project is:

> **Do not spend weeks building toward the first useful version. Start with working MeshCentral from our fork, deploy it, use it, then improve the things that actually hurt.**

The first milestone is not a beautiful Beacon product.

The first milestone is:

> **Hudson's fork is live, secure enough for controlled use, remotely managing Windows machines, in both test and production.**

From there, every real support call helps define the product.

For v1, however, five known gaps are already accepted work and must not be deferred merely because stock MeshCentral is usable:

1. temporary-session privilege elevation/UAC
2. the Phase 0-selected customer/site/device hierarchy
3. reliable automatic clipboard
4. a polished six-digit quick-support flow
5. a unified managed-endpoint experience combining MeshAgent and Assistant-style functions under one Beacon installation/product identity

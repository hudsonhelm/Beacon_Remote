# Phase 1 — Infrastructure Discovery and Environment Design

## Status

Phase 1 completed on September 15, 2026. The environment design is approved, and unavailable provider specifications are explicitly accepted as uncertainties subject to post-rebuild monitoring. No VPS installation or configuration was performed in this phase.

## Verified Hosting Inventory

- Provider: OVHcloud
- Service name: `vps-a151efb8.vps.ovh.ca`
- Offer label: `VPS-1 2026`
- Region/zone: Beauharnois, Canada (`os-bhs6`)
- Status: active with automatic renewal and no term commitment
- Compute: 4 vCores
- Memory: 8 GB
- Storage capacity: 75 GB
- IPv4: `51.222.25.62`
- IPv6: `2607:5300:205:200::92b2`
- IPv6 gateway: `2607:5300:205:200::1`
- Reverse DNS: the IPv4 address resolves to the OVHcloud VPS service name
- Additional disks: disabled
- OVHcloud Snapshot option: enabled
- OVHcloud Automated Backup: Standard, active; a backup was shown for September 15, 2026 at 20:00
- OVHcloud Anti-DDoS: automatic for IPv4
- OVHcloud Edge Firewall: disabled for IPv4

The OVHcloud control panel did not identify an installed OS and offered only `Reinstall my VPS`. The read-only KVM console subsequently confirmed that the local disk boots the untouched OVHcloud default Ubuntu 25.10 image to a login prompt. Its login banner advertises a web console on TCP 9090. External checks found ports 22, 80, 443, 4433, and 9090 closed. Nelson confirmed that he has never logged in to or modified the VPS. Phase 2 will erase this disposable non-LTS default installation and replace it with a supported minimal Ubuntu Server LTS image, so its current guest services, users, firewall, sudo configuration, and SSH authentication state do not need further inventory.

OVHcloud's daily monitoring view showed low processor use of roughly 3–4%, low background network traffic with intermittent bursts, and reported RAM usage near 98% throughout the displayed period. Those graphs confirm that the VM is running, but they do not identify the responsible processes or establish whether the RAM figure reflects guest workload, cache accounting, or a provider-metric issue.

The exact storage medium and contracted bandwidth were not displayed in the supplied control-panel views. Current OVHcloud offers with the same 4-vCore, 8-GB, 75-GB resource profile advertise NVMe storage and 1 Gbps unlimited public traffic, but those characteristics remain unverified for this `VPS-1 2026` contract and must not be represented as confirmed. Nelson accepted this uncertainty for the initial deployment. Phase 2 will verify actual disk and network behavior after rebuild, and sustained resource use will determine whether test must move to a separate VPS.

## Environment Topology Decision

Test and production will initially share this VPS. The available 4 vCores and 8 GB RAM are sufficient for Hudson Helm's initial low-volume use, provided utilization and storage are monitored.

Isolation is mandatory:

- separate Docker Compose projects
- separate application containers
- separate database containers and databases
- separate persistent volumes
- separate configuration and secret files
- separate administrator credentials
- separate backup sets
- separate hostnames
- no production data, credentials, or mounted volumes in test

If sustained memory, CPU, disk, or operational risk makes co-location unsuitable, test will move to a separate VPS without changing the production identity.

## Host Operating System

Use the current OVHcloud-provided minimal Ubuntu Server LTS image, preferring Ubuntu Server 24.04 LTS if it is available in the reinstall workflow. Do not install a prepackaged application image or a control panel. Phase 2 must record the exact selected image and version before installation.

Administrative access will use SSH keys. Direct password-only root administration is not the intended steady state. Phase 2 will establish a non-root sudo administrator and harden SSH before application deployment.

## DNS and TLS Plan

- Production: `remote.hudsonhelm.com`
- Test/staging: `remote-test.hudsonhelm.com`
- DNS provider: Cloudflare
- Initial Cloudflare mode: DNS-only, not proxied
- Both A records may initially resolve to the shared VPS IPv4 address.
- Do not publish AAAA records until IPv6 routing and the host firewall have been configured and tested.
- Use NGINX on the VPS as the public reverse proxy and TLS endpoint.
- Route each hostname to its own internal Beacon container endpoint.
- Validate WebSockets, agent connectivity, forwarded client addresses, certificate discovery, and reconnect behavior before either environment is accepted.

Cloudflare proxying may be evaluated later, but it is not part of the initial network path.

## Port Plan

| Port | Exposure | Purpose |
|---|---|---|
| TCP 22 | Restricted to approved administrative sources where practical | SSH administration |
| TCP 80 | Public | ACME HTTP challenge and redirect to HTTPS |
| TCP 443 | Public | NGINX TLS endpoint for browser, WebSocket, and agent traffic |
| TCP 4433 | Closed initially | MeshCentral Intel AMT/MPS; open only when that capability is deliberately configured and tested |

Database ports and internal application ports must not be publicly exposed. Apply equivalent IPv4 and IPv6 firewall policy before publishing AAAA records.

## Backup Approach

Use layered recovery rather than treating a provider image as the only backup:

1. Keep OVHcloud Standard automated backup enabled for host-level recovery.
2. Take an OVHcloud snapshot before significant host changes, upgrades, or production releases when appropriate.
3. Create application-consistent backups for each environment's database, MeshCentral data, files, configuration, and required certificates.
4. Store encrypted application backups off the VPS; the exact destination remains an open infrastructure decision.
5. Test restore and rollback in the later recovery-validation phase.

Provider backups and snapshots do not replace application-level, off-server backups.

## Infrastructure Discovery Checklist

- [x] Cloud provider
- [x] vCPU
- [x] RAM
- [x] Disk capacity
- [x] Disk type: unavailable from the supplied OVHcloud views; uncertainty explicitly accepted
- [x] Contracted bandwidth allowance: unavailable from the supplied OVHcloud views; uncertainty explicitly accepted
- [x] Installed operating system and version: Ubuntu 25.10
- [x] Public IPv4 and IPv6 addressing
- [x] OVHcloud firewall/security-group configuration: Edge Firewall disabled; Anti-DDoS automatic
- [x] Existing services on the VPS: not applicable; untouched default installation will be erased
- [x] Provider snapshot/backup capability
- [x] Current root/sudo access method: not applicable; credentials and sudo policy will be replaced
- [x] Whether SSH-key authentication is already configured: not applicable; authorized keys will be replaced

Items marked not applicable are deliberately disposed of by the approved clean reinstall; they are not being represented as verified properties of the current guest.

## Phase 1 Exit Checklist

- [x] Hosting location known.
- [x] Required infrastructure inventory complete or explicitly dispositioned.
- [x] Test/production topology chosen.
- [x] Host OS family and access approach chosen.
- [x] DNS and initial proxy plan chosen.
- [x] Required public ports identified.
- [x] Backup approach identified.
- [x] No production or test deployment performed prematurely.

## Accepted Limitations and Phase 2 Handoff

- Storage type and contracted bandwidth remain unknown and must not be claimed as confirmed specifications.
- Monitor real disk, memory, CPU, and network behavior after the clean rebuild.
- Move test to a separate VPS if sustained utilization or operational risk makes shared hosting unsuitable.
- Record the new administrative SSH key, sudo policy, guest firewall, exposed services, and exact Ubuntu image during Phase 2.

Phase 1 is closed with these limitations accepted. Selecting the installation SSH key, reinstalling the VPS, configuring IPv6, and implementing the off-server backup destination are Phase 2 or later implementation actions. VPS reinstallation is destructive and will begin only with explicit approval.

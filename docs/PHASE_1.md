# Phase 1 — Infrastructure Discovery and Environment Design

## Status

Phase 1 is in progress. The environment design is recorded, but the original infrastructure-discovery checklist is not yet complete. No VPS installation or configuration has been performed.

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

The OVHcloud control panel did not identify an installed OS and offered only `Reinstall my VPS`. External checks found ports 22, 80, 443, and 4433 closed. Because the VPS has never been used and exposes no reachable service, Phase 2 will treat it as a blank host and install a supported minimal Ubuntu Server LTS image.

The exact storage medium and contracted bandwidth were not displayed in the supplied control-panel views. Current OVHcloud offers with the same 4-vCore, 8-GB, 75-GB resource profile advertise NVMe storage and 1 Gbps unlimited public traffic, but those characteristics remain unverified for this `VPS-1 2026` contract and must not be represented as confirmed.

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
- [ ] Disk type
- [ ] Contracted bandwidth allowance
- [ ] Installed operating system and version, or definitive confirmation that no OS is installed
- [x] Public IPv4 and IPv6 addressing
- [ ] OVHcloud firewall/security-group configuration
- [ ] Existing services on the VPS
- [x] Provider snapshot/backup capability
- [ ] Current root/sudo access method
- [ ] Whether SSH-key authentication is already configured

Closed external ports and a blank OS field are observations, not proof of the current firewall, service, operating-system, or authentication configuration.

## Phase 1 Exit Checklist

- [x] Hosting location known.
- [ ] Required infrastructure inventory complete.
- [x] Test/production topology chosen.
- [x] Host OS family and access approach chosen.
- [x] DNS and initial proxy plan chosen.
- [x] Required public ports identified.
- [x] Backup approach identified.
- [x] No production or test deployment performed prematurely.

## Remaining Phase 1 Items

- Determine the current OS state without initiating a reinstall.
- Confirm the contracted storage type and bandwidth from OVHcloud service or billing details.
- Inspect the OVHcloud network firewall/security configuration.
- Determine whether any services exist on the VPS rather than inferring their absence from closed ports.
- Determine the current root/sudo access and SSH-key state.

After those observations are recorded, Phase 1 can close. Selecting the installation SSH key, reinstalling the VPS, configuring IPv6, and implementing the off-server backup destination are Phase 2 or later implementation actions. VPS reinstallation is destructive and will begin only with explicit approval.

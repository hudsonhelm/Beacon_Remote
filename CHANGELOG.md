# Changelog

This file records changes made specifically for Beacon on top of upstream MeshCentral.

## Unreleased

### Added

- Established the Hudson-controlled MeshCentral fork and Phase 0 repository baseline.
- Adopted Beacon as the product-family name.
- Recorded the upstream source, update procedure, branch model, and baseline commit.
- Selected the fixed Customer → Site → Device MSP hierarchy with tags for cross-cutting organization.
- Renamed the remote-management repository from `Beacon` to `Beacon_Remote`.
- Established `Beacon` as the product-family name and `Beacon_<Module>` as the repository naming convention for product-line modules.
- Began the Phase 1 OVHcloud infrastructure inventory and recorded the initial shared-host topology, Ubuntu LTS target, Cloudflare DNS-only plan, NGINX reverse proxy, public-port plan, and layered-backup approach.
- Corrected Phase 1 to in progress after a strict audit identified unverified storage, bandwidth, OS, firewall, service, and administrative-access details.
- Completed Phase 1 after verifying the current Ubuntu and OVHcloud network state, explicitly accepting unavailable storage-type and bandwidth details, and dispositioning the untouched guest configuration as superseded by the clean Phase 2 rebuild.
- Completed Phase 2 by rebuilding the OVHcloud VPS on Ubuntu 24.04 LTS, installing all updates, creating the key-only `beaconadmin` sudo account, hardening SSH, enabling UFW and Fail2ban, and validating reboot recovery.
- Installed and verified Docker Engine 29.8.1, Docker Compose v5.5.1, containerd, NGINX, time synchronization, unattended upgrades, troubleshooting utilities, Docker log rotation, and live restore.
- Added the reproducible two-stage host setup script and documented the firewall, external port results, backup exception, local-only credential handling, and temporary host-baseline limitations in `docs/PHASE_2.md`.
- Completed Phase 3 by adding OCI source/version metadata to the inherited Docker build and a reproducible image build and HTTPS smoke-test script.
- Built and verified the Hudson-controlled `beacon-remote:0.1.0-hudson.1` image from Beacon commit `eb8869064d7771565368fecd7d578e657d3061d0` and upstream MeshCentral baseline `9f328938a355b778b037435dbc61ef89731f71ad`.
- Added Phase 3.5, **Baseline Beacon Remote Identity**, as a hard gate before any persistent staging or production environment.
- Defined **Beacon** as the product family, **Beacon Remote** as this product, **Beacon Agent** as the managed endpoint agent, and **Beacon Assistant** as the tray/support assistant.
- Re-scoped Phase 7 from baseline de-MeshCentral branding to later visual polish and cohesive product identity.
- Implemented and clean-build verified the Phase 3.5 identity layer with the approved Beacon asset package, mandatory container branding overlay, Beacon Remote web identity, Beacon Agent installer/service/executable metadata, Beacon Assistant presentation, branded consent and notification messages, and targeted modern-UI naming changes. Phase acceptance remains pending isolated Windows installed-surface validation and explicit acceptance or resolution of the signed Assistant VersionInfo exception.

No functional MeshCentral customizations are included in this bootstrap change.

# Phase 2 — Server Baseline and Docker Host Preparation

## Status

Phase 2 completed on September 17, 2026. The OVHcloud VPS was erased, rebuilt with Ubuntu Server 24.04 LTS, patched, hardened, rebooted, and verified as a healthy Docker host. No Beacon application or database was deployed in this phase.

## Host Baseline

| Item | Verified state |
|---|---|
| Host | `vps-a151efb8.vps.ovh.ca` |
| IPv4 | `51.222.25.62` |
| IPv6 | `2607:5300:205:200::92b2` |
| Installed image | OVHcloud Ubuntu 24.04 image |
| Patched OS | Ubuntu 24.04.5 LTS |
| Kernel after reboot | `6.8.0-139-generic` |
| CPU | 4 vCPUs |
| Memory | 7.6 GiB usable |
| Swap | None |
| Disk | 75 GB QEMU virtual disk; 72 GB ext4 root filesystem, 69 GB free after baseline setup |
| Time | UTC; system clock synchronized; `systemd-timesyncd` active |

The clean reinstall replaced the untouched Ubuntu 25.10 guest recorded in Phase 1. The supplied ED25519 public key was injected during installation. The local key fingerprint is `SHA256:dssomfLcXLrMab6kTW99oYtcXErKaiYsAk2wZ858wTg`.

## Administrative Access

- Primary administrator: `beaconadmin`, a non-root member of `sudo` and `docker`.
- Authentication: SSH public key only.
- Sudo policy: passwordless sudo for the key-authenticated `beaconadmin` account.
- Effective SSH policy: `PermitRootLogin no`, `PasswordAuthentication no`, `KbdInteractiveAuthentication no`, and `PubkeyAuthentication yes`.
- SSH uses Ubuntu's enabled and active `ssh.socket` for automatic startup.
- The OVH installer account remains available by SSH key as an emergency recovery account; remote password authentication is disabled globally.
- The Docker group is root-equivalent. Membership is intentionally limited to `beaconadmin`.

The local-only credential record is `.local-secrets/phase2-vps-credentials.txt`. The directory is Git-ignored and restricted to the local Windows administrator. No password, private key, or secret is stored in tracked project files.

## Installed Host Services

| Service/tool | Verified state |
|---|---|
| Docker Engine | `29.8.1`; enabled and active |
| Docker Compose plugin | `v5.5.1` |
| containerd | `2.3.5`; enabled and active |
| Docker storage/logging | `overlayfs`; `json-file` with 10 MB rotation and three retained files |
| Docker restart behavior | `live-restore` enabled; Docker and containerd enabled at boot |
| Docker functional test | Official `hello-world` container completed successfully |
| NGINX | Installed, enabled, active, and configuration-tested |
| Fail2ban | Enabled and active with the `sshd` jail and UFW ban action |
| Unattended upgrades | Enabled |
| Utilities | Git, curl, jq, unzip, Vim, htop, DNS and network tools installed |

NGINX is the selected reverse proxy. Its temporary catch-all listener returns HTTP 404 and does not expose a welcome or application page. TLS and the Beacon proxy configuration are not part of Phase 2.

## Firewall and Exposed Ports

UFW is enabled with deny incoming, allow outgoing, and deny routed defaults. IPv4 and IPv6 rules are present.

| Port | Host rule | External result | Purpose |
|---|---|---|---|
| TCP 22 | Allowed | Reachable | Key-only SSH administration |
| TCP 80 | Allowed | Reachable; HTTP 404 | NGINX reverse-proxy/HTTP entry point |
| TCP 443 | Allowed | Not listening yet | Reserved HTTPS entry point |
| TCP 4433 | Not allowed | Closed | Direct MeshCentral exposure is not permitted |
| TCP 3306 | Not allowed | Closed | Database port |
| TCP 5432 | Not allowed | Closed | Database port |
| TCP 27017 | Not allowed | Closed | Database port |

No application or database container publishes a host port. Docker-managed published ports can bypass ordinary UFW forwarding behavior, so later Compose definitions must avoid public database bindings and must expose Beacon only through the reverse proxy or an explicit `DOCKER-USER` policy.

## Backup and Recovery State

OVHcloud Standard automated backup remains enabled. A manual provider snapshot was created before the clean reinstall on September 16, 2026 at 19:38, and the control panel showed a Standard automated backup from 20:00. At the user's direction, no additional post-baseline snapshot was taken because the rebuilt server contains no user or application data. The setup is reproducible from `tools/phase2-host-setup.sh` plus the locally held SSH key and credential record.

## Reboot and Exit Validation

- Installed all normal and phased Ubuntu updates; no packages remained upgradeable.
- Rebooted into kernel `6.8.0-139-generic`.
- Reconnected as `beaconadmin` using public-key authentication with password authentication explicitly disabled client-side.
- Confirmed passwordless sudo and effective SSH policy after reboot.
- Confirmed Docker, containerd, NGINX, Fail2ban, and time synchronization returned active.
- Confirmed Docker Compose and Docker daemon health after reboot.
- Confirmed UFW rules and external port behavior.
- Confirmed NGINX syntax and the intentional HTTP 404 catch-all response.
- Confirmed that no further reboot was required.

## Temporary Placeholders, Accepted Limitations, and Deferred Phase 2 Items

- TCP 443 is permitted by UFW but has no listener until TLS is configured with the application-facing proxy.
- NGINX serves only a temporary catch-all HTTP 404 response; it is not a Beacon site.
- SSH is open to the Internet because no stable administrative source range was available. Key-only authentication, root-login denial, UFW logging, and Fail2ban mitigate this; source restriction can be added when a stable range or VPN exists.
- The provider snapshot and automated-backup restore points predate the rebuilt baseline. A new snapshot was explicitly skipped because the host has no user or application data; provider automated backup remains enabled.
- No swap is configured. With 7.6 GiB available and no workload deployed, this is not a Phase 2 blocker; resource use must be observed once containers exist.

These items do not prevent Phase 3 from beginning. Phase 2's exit criteria are satisfied with the documented backup exception accepted by the user.

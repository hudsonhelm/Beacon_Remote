#!/usr/bin/env bash
set -Eeuo pipefail

export DEBIAN_FRONTEND=noninteractive

ADMIN_USER="beaconadmin"
PUBLIC_KEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPDqv41xJMceEJOmwIEVSYOEiDPsksALDiO9+3tMxfr2"
MODE="${1:-}"

bootstrap() {
  apt-get update
  apt-get -o APT::Get::Always-Include-Phased-Updates=true -y full-upgrade
  apt-get install -y \
    ca-certificates curl gnupg git jq unzip vim htop dnsutils net-tools \
    ufw fail2ban nginx unattended-upgrades

  if ! id -u "${ADMIN_USER}" >/dev/null 2>&1; then
    adduser --disabled-password --gecos "Beacon administrator" "${ADMIN_USER}"
  fi
  usermod -aG sudo "${ADMIN_USER}"
  install -d -m 0700 -o "${ADMIN_USER}" -g "${ADMIN_USER}" "/home/${ADMIN_USER}/.ssh"
  printf '%s\n' "${PUBLIC_KEY}" > "/home/${ADMIN_USER}/.ssh/authorized_keys"
  chown "${ADMIN_USER}:${ADMIN_USER}" "/home/${ADMIN_USER}/.ssh/authorized_keys"
  chmod 0600 "/home/${ADMIN_USER}/.ssh/authorized_keys"

  install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  chmod a+r /etc/apt/keyrings/docker.asc
  . /etc/os-release
  printf 'deb [arch=%s signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu %s stable\n' \
    "$(dpkg --print-architecture)" "${UBUNTU_CODENAME:-$VERSION_CODENAME}" \
    > /etc/apt/sources.list.d/docker.list
  apt-get update
  apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  install -d -m 0755 /etc/docker
  cat > /etc/docker/daemon.json <<'EOF'
{
  "live-restore": true,
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
EOF
  usermod -aG docker "${ADMIN_USER}"
  systemctl enable docker containerd nginx
  systemctl restart docker
  systemctl restart nginx
  systemctl enable --now systemd-timesyncd
  systemctl enable unattended-upgrades

  echo 'Bootstrap completed. Verify beaconadmin SSH access before hardening.'
}

harden() {
  test -s "/home/${ADMIN_USER}/.ssh/authorized_keys"
  id -u "${ADMIN_USER}" >/dev/null

  cat > "/etc/sudoers.d/90-${ADMIN_USER}" <<EOF
${ADMIN_USER} ALL=(ALL:ALL) NOPASSWD: ALL
EOF
  chmod 0440 "/etc/sudoers.d/90-${ADMIN_USER}"
  visudo -cf "/etc/sudoers.d/90-${ADMIN_USER}"

  rm -f /etc/ssh/sshd_config.d/99-beacon-hardening.conf
  cat > /etc/ssh/sshd_config.d/01-beacon-hardening.conf <<'EOF'
PubkeyAuthentication yes
PasswordAuthentication no
KbdInteractiveAuthentication no
PermitRootLogin no
X11Forwarding no
EOF
  sshd -t
  systemctl reload ssh

  ufw --force reset
  ufw default deny incoming
  ufw default allow outgoing
  ufw allow 22/tcp comment 'SSH administration'
  ufw allow 80/tcp comment 'HTTP reverse proxy'
  ufw allow 443/tcp comment 'HTTPS reverse proxy'
  ufw logging low
  ufw --force enable

  cat > /etc/fail2ban/jail.d/sshd.local <<'EOF'
[sshd]
enabled = true
banaction = ufw
backend = systemd
maxretry = 5
findtime = 10m
bantime = 1h
EOF
  systemctl enable --now fail2ban

  cat > /etc/nginx/sites-available/default <<'EOF'
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name _;
    return 404;
}
EOF
  nginx -t
  systemctl reload nginx

  docker run --rm hello-world

  {
    echo '=== OS ==='
    cat /etc/os-release
    uname -a
    echo '=== CPU and memory ==='
    nproc
    free -h
    echo '=== Storage ==='
    lsblk -o NAME,MODEL,TYPE,SIZE,FSTYPE,MOUNTPOINTS
    df -hT
    echo '=== Network ==='
    ip -br address
    ip route
    echo '=== Time ==='
    timedatectl
    echo '=== Firewall ==='
    ufw status verbose
    echo '=== Services ==='
    systemctl is-enabled ssh.socket docker containerd nginx fail2ban systemd-timesyncd unattended-upgrades
    systemctl is-active ssh.socket ssh docker containerd nginx fail2ban systemd-timesyncd
    echo '=== Docker ==='
    docker version
    docker compose version
    docker info
    echo '=== Listening ports ==='
    ss -lntup
    echo '=== Reboot required ==='
    test -f /var/run/reboot-required && cat /var/run/reboot-required || echo no
  } > /root/phase2-evidence.txt

  echo 'Hardening completed.'
}

case "${MODE}" in
  bootstrap) bootstrap ;;
  harden) harden ;;
  *) echo "Usage: $0 {bootstrap|harden}" >&2; exit 2 ;;
esac

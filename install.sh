#!/usr/bin/env bash
set -euo pipefail

SRC_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPT="$SRC_DIR/battery-monitor.sh"
UNIT="$SRC_DIR/battery-monitor.service"

DEST_SCRIPT="/usr/local/bin/battery-monitor.sh"
DEST_UNIT="/etc/systemd/system/battery-monitor.service"

# Fail early if not root
if [[ $EUID -ne 0 ]]; then
    echo "Please run as root (sudo $0)" >&2
    exit 1
fi

# 1. Install the script with correct mode/owner
install -m 0755 -o root -g root "$SCRIPT" "$DEST_SCRIPT"

# 2. Relabel for SELinux if enforcing
if command -v selinuxenabled >/dev/null && selinuxenabled; then
    restorecon -v "$DEST_SCRIPT"
fi

# 3. Install the unit file
install -m 0644 -o root -g root "$UNIT" "$DEST_UNIT"

# 4. Reload, enable, start
systemctl daemon-reload
systemctl enable --now battery-monitor.service

# 5. Report status
systemctl status battery-monitor.service --no-pager

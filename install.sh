#!/bin/bash
set -euo pipefail

SRC="$(cd "$(dirname "$0")" && pwd)/battery-monitor.sh"
DST="/usr/local/bin/battery-monitor.sh"

sudo install -m 0755 -o root -g root "$SRC" "$DST"

# Relabel if SELinux is enforcing
if command -v selinuxenabled >/dev/null && selinuxenabled; then
    sudo restorecon -v "$DST"
fi

echo "Installed to $DST"
echo "Now enable the service, e.g.:"
echo "  sudo cp battery-monitor.service /etc/systemd/system/"
echo "  sudo systemctl daemon-reload"
echo "  sudo systemctl enable --now battery-monitor.service"

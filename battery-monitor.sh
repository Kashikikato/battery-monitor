#!/bin/bash
# Battery charge limiter for IdeaPad 5 Pro
# Caps charge at UPPER%, resumes at LOWER% using the conservation_mode sysfs node.
set -euo pipefail

# --- Config ---
UPPER=80          # stop charging at or above this %
LOWER=75          # resume charging at or below this %
INTERVAL=10       # seconds between checks
BATTERY=$(ls /sys/class/power_supply | grep "BAT*")    # check ls /sys/class/power_supply/ or upower -e for the right name
BAT_PATH="/sys/class/power_supply/$BATTERY"
MODE_PATH="/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode"

log() { echo "[$(date '+%F %T')] $*"; }

log "Starting. MODE_PATH=$MODE_PATH UPPER=$UPPER LOWER=$LOWER"

while true; do
    pct=$(cat "$BAT_PATH/capacity")
    mode=$(cat "$MODE_PATH")

   if ((pct >= UPPER)); then
      bash -c "echo 1 > $MODE_PATH"
      log "Capacity ${pct}% >= ${UPPER}% -> charging DISABLED (conservation_mode=$(cat $MODE_PATH))"
   elif ((pct <= LOWER)); then
      bash -c "echo 0 > $MODE_PATH"
      log "Capacity ${pct}% <= ${LOWER}% -> charging ENABLED (conservation_mode=$(cat $MODE_PATH))"
   elif ((pct < UPPER)) && ((pct > LOWER)); then
     log "Capacity ${pct}% < UPPER and ${pct}% > LOWER -> the weird phase in between where it could be both... Schroedinger's charging state you could say"
   fi

   sleep "$INTERVAL"
done

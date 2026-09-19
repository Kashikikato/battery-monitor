# battery-monitor
A simple battery monitor script to customize the charging threshold for laptops that use **conservation mode** (most Lenovo non-Thinkpad laptops afaik). Conservation mode can either be disabled or enabled (set to 0 or 1). When enabled, charging will stop at 60% and start again once the battery percentage drops to 55%. This script allows laptops that use this feature to extend or limit the charging threshold to any custom percentage value. The threshold in this script is set to 80%, but can be adjusted in the initialization of the constant UPPER (line 7):

`UPPER=80          # stop charging at or above this %`

I made this script for my Ideapad 5 Pro, which uses the conservation mode feature. 

### NOTES ###

The paths in the script are valid for my computer, which does not guarantee that everything works out of the box for you as well. Please verify the correct values before using the scripts:

The script searches your battery by checking for **/sys/class/power_supply/BAT***. If your battery is not found by this wildcard you need to adjust the BATTERY constant in the script.

Check for your battery:

`ls /sys/class/power_supply` 

Return the conservation mode value (0 or 1):

`cat /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode` -> Please find out the correct path for your laptop.

### USAGE

Navigate to the cloned directory and run:

`sudo ./install.sh`

Check status with:

`sudo systemctl status battery-monitor.service`

Check logs with:

`sudo journalctl -u battery-monitor.service -f`

Remove symlink and script in /usr/local/bin:

```
sudo systemctl disable --now battery-monitor.service
sudo rm /etc/systemd/system/batter-monitor.service
sudo rm /usr/local/bin/battery-monitor.sh
```



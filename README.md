# battery-monitor
A simple battery monitor script that can be run as a systemd service for laptops that use conservation mode. Conservation mode can either be enabled or disabled. When enabled, charging will stop at 60% and start again once the battery percentage drops to 55%. This script allows laptops that use this feature to extend the charging threshold to a custom threshold. The threshold in this script is set to 80%, but can be adjusted in the initialization of the constant UPPER (line 7). I made this script for my Ideapad 5 Pro, which uses the conservation mode. 

### NOTES ###

The paths in the script are valid for my computer, which does not guarantee that everything works out of the box for you as well. Please verify the correct values before using the scripts:
ls /sys/class/power_supply -> find your battery
cat /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode returns the conservation mode value for me (0 or 1). Please find out the correct path for your laptop. 

### USAGE

The script is meant to be used in a systemd service. Create this service for your script by following these steps:

Create and open the service file:
$ sudo nano /etc/systemd/system/battery-monitor.service

Paste the following with the correct ExecStart path in the file:
  [Unit]
  Description=Battery charge limiter (80% cap)
  After=multi-user.target
  
  [Service]
  Type=simple
  ExecStart=/usr/local/bin/battery_monitor.sh # my script is saved in /usr/local/bin, change your path according to where you saved your script
  Restart=always
  RestartSec=10
  User=root
  
  [Install]
  WantedBy=multi-user.target

Run:
  sudo systemctl daemon-reload
  sudo systemctl enable battery-monitor.service
  sudo systemctl start battery-monitor.service

Check status with:
  sudo systemctl status battery-monitor.service

Check logs with:
  sudo journalctl -u battery-monitor.service -f


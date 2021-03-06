#!/bin/bash

if [ $# -eq 0 ]; then
 echo "small config script to switch the LND auto pilot on or off"
 echo "lnd.autopilot.sh [1|0]"
 exit 1
fi

# check lnd.conf exits 
lndConfExists=$(sudo ls /mnt/hdd/lnd/lnd.conf | grep -c 'lnd.conf')
if [ ${lndConfExists} -eq 0 ]; then
  echo "FAIL - /mnt/hdd/lnd/lnd.conf not found"
  exit 1
fi

# check if "autopilot.active" exists
valueExists=$(sudo cat /mnt/hdd/lnd/lnd.conf | grep -c 'autopilot.active=')
if [ ${valueExists} -eq 0 ]; then
  echo "Adding autopilot config defaults to /mnt/hdd/lnd/lnd.conf"
  sudo sed -i '$ a [autopilot]' /mnt/hdd/lnd/lnd.conf
  sudo sed -i '$ a autopilot.active=0' /mnt/hdd/lnd/lnd.conf
  sudo sed -i '$ a autopilot.allocation=0.6' /mnt/hdd/lnd/lnd.conf
  sudo sed -i '$ a autopilot.maxchannels=5' /mnt/hdd/lnd/lnd.conf
fi

# switch on
if [ $1 -eq 1 ] || [ "$1" = "on" ]; then
  echo "switching the LND autopilot ON"
  sudo sed -i "s/^autopilot.active=.*/autopilot.active=1/g" /mnt/hdd/lnd/lnd.conf
  exit 0
fi

# switch off
if [ $1 -eq 0 ] || [ "$1" = "off" ]; then
  echo "switching the LND autopilot OFF"
  sudo sed -i "s/^autopilot.active=.*/autopilot.active=0/g" /mnt/hdd/lnd/lnd.conf
  exit 0
fi

echo "FAIL - Unknown Paramter $1"
exit 1
#!/bin/bash

# Spuštění původního skriptu
echo "Spouštím původní alpine-docker.sh z community-scripts..."
output=$(bash -c "$(wget -qO - https://github.com/community-scripts/ProxmoxVE/raw/main/ct/alpine-docker.sh)")

# Extrakce hodnot z výstupu původního skriptu
VMID=$(echo "$output" | grep -oP 'Using Virtual Machine ID: \K\d+')
MAC_ADDRESS=$(echo "$output" | grep -oP 'Using MAC Address: \K[0-9A-Fa-f:]+')

# Zobrazení výsledků
echo "VMID: $VMID"
echo "MAC Address: $MAC_ADDRESS"

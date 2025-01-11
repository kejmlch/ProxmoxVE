#!/bin/bash

# Spuštění původního skriptu a uložení výstupu
echo "Spouštím původní alpine-docker.sh z community-scripts..."
output=$(bash <(wget -qO - https://github.com/community-scripts/ProxmoxVE/raw/main/ct/alpine-docker.sh))

# Extrakce VMID a MAC_ADDRESS z výstupu
VMID=$(echo "$output" | grep -oP 'Using Virtual Machine ID: \K\d+')
MAC_ADDRESS=$(echo "$output" | grep -oP 'Using MAC Address: \K[0-9A-Fa-f:]+')

# Zobrazení výsledků
echo "VMID je $VMID a MAC adresa je $MAC_ADDRESS"

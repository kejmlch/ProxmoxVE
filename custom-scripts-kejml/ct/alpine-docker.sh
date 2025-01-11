#!/bin/bash

# Spuštění původního skriptu z community-scripts
echo "Spouštím původní alpine-docker.sh z community-scripts..."
source <(wget -qO - https://github.com/community-scripts/ProxmoxVE/raw/main/ct/alpine-docker.sh)
echo "VMID je $VMID a MAC adresa je $MAC_ADDRESS"

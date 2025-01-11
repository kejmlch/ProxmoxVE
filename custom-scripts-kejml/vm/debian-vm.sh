#!/bin/bash

# Spuštění původního skriptu z community-scripts
echo "Spouštím původní debian-vm.sh z community-scripts..."
source <(wget -qO - https://github.com/community-scripts/ProxmoxVE/raw/main/vm/debian-vm.sh)
echo "VMID je $VMID a MAC adresa je $MAC_ADDRESS"

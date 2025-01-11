#!/bin/bash

# Spuštění původního skriptu z community-scripts
echo "Spouštím původní debian-vm.sh z community-scripts..."
bash -c "$(wget -qLO - https://github.com/community-scripts/ProxmoxVE/raw/main/vm/debian-vm.sh)"

# Získání posledního vytvořeného ID
echo "Zjišťuji ID posledního vytvořeného CT nebo VM..."
VMID=$(pvesh get /cluster/nextid)
VMID=$((VMID - 1)) # ID nově vytvořeného je o 1 nižší než další volné ID
echo "Nově vytvořené ID je: $VMID"

# Určení typu (CT nebo VM) a zjištění MAC adresy
if pct config "$VMID" > /dev/null 2>&1; then
  TYPE="CT"
  MAC_ADDRESS=$(pct config $VMID | grep -oP 'hwaddr=\K[^,]+')
elif qm config "$VMID" > /dev/null 2>&1; then
  TYPE="VM"
  MAC_ADDRESS=$(qm config $VMID | grep -oP 'macaddr=\K[^,]+')
else
  echo "ID $VMID není platný CT ani VM. Skript končí."
  exit 1
fi

# Zobrazení výsledků
echo "Nově vytvořený objekt:"
echo "Typ: $TYPE"
echo "ID: $VMID"
echo "MAC adresa: $MAC_ADDRESS"

# Další krok: přidání rezervace do DHCP (zatím neimplementováno)
echo "Rezervace do DHCP zatím není implementována."

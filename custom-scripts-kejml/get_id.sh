#!/bin/bash

# Získání poslední vytvořené operace z logu
LOG_ENTRY=$(grep 'create' /var/log/pve/tasks/index | tail -n 1)

# Extrakce ID a typu
VMID=$(echo "$LOG_ENTRY" | grep -oP '\svm/\K\d+|\slxc/\K\d+')
if echo "$LOG_ENTRY" | grep -q 'lxc/'; then
  TYPE="CT"
elif echo "$LOG_ENTRY" | grep -q 'vm/'; then
  TYPE="VM"
else
  echo "Nepodařilo se určit typ posledního vytvořeného objektu."
  exit 1
fi

# Získání MAC adresy
if [ "$TYPE" == "VM" ]; then
  MAC_ADDRESS=$(qm config "$VMID" | grep -oP 'macaddr=\K[^,]+')
elif [ "$TYPE" == "CT" ]; then
  MAC_ADDRESS=$(pct config "$VMID" | grep -oP 'hwaddr=\K[^,]+')
fi

# Výstup výsledků
echo "Naposledy vytvořený objekt je typu: $TYPE s ID: $VMID"
echo "MAC adresa: $MAC_ADDRESS"

#!/bin/bash

# Zjištění ID naposledy vytvořeného VM
LATEST_VM_CONFIG=$(ls -t /etc/pve/qemu-server/ | head -n 1)
LATEST_VM_ID=${LATEST_VM_CONFIG%%.conf}

# Zjištění ID naposledy vytvořeného CT
LATEST_CT_CONFIG=$(ls -t /etc/pve/lxc/ | head -n 1)
LATEST_CT_ID=${LATEST_CT_CONFIG%%.conf}

# Porovnání a určení naposledy vytvořeného objektu
if [ -z "$LATEST_VM_ID" ]; then
  VMID=$LATEST_CT_ID
  TYPE="CT"
elif [ -z "$LATEST_CT_ID" ]; then
  VMID=$LATEST_VM_ID
  TYPE="VM"
else
  if [ "$LATEST_VM_ID" -gt "$LATEST_CT_ID" ]; then
    VMID=$LATEST_VM_ID
    TYPE="VM"
  else
    VMID=$LATEST_CT_ID
    TYPE="CT"
  fi
fi

echo "Naposledy vytvořený objekt je typu: $TYPE s ID: $VMID"

# Získání MAC adresy
if [ "$TYPE" == "VM" ]; then
  MAC_ADDRESS=$(qm config $VMID | grep -oP 'net\d+: \K.*' | grep -oP 'macaddr=\K[^,]+')
else
  MAC_ADDRESS=$(pct config $VMID | grep -oP 'net\d+: \K.*' | grep -oP 'hwaddr=\K[^,]+')
fi

echo "MAC adresa: $MAC_ADDRESS"

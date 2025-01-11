#!/bin/bash

# Získání posledního vytvořeného VMID
VMID=$(grep 'create' /var/log/pve/tasks/index | tail -n 1 | grep -oP '(?<=:)\d+(?=:root@pam)')

# Ověření, zda VMID bylo nalezeno
if [ -z "$VMID" ]; then
  echo "Nepodařilo se zjistit ID posledního vytvořeného objektu."
  exit 1
fi

# Získání MAC adresy z konfigurace
if [ -f "/etc/pve/qemu-server/$VMID.conf" ]; then
  MAC_ADDRESS=$(qm config "$VMID" | grep -oP 'macaddr=\K[^,]+')
elif [ -f "/etc/pve/lxc/$VMID.conf" ]; then
  MAC_ADDRESS=$(pct config "$VMID" | grep -oP 'hwaddr=\K[^,]+')
else
  echo "Nepodařilo se najít konfiguraci pro ID: $VMID."
  exit 1
fi

# Zjištění IP adresy (pouze pro kontejnery, pokud existuje IP nastavení)
IP_ADDRESS=$(grep -oP "ip=\K[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" <<< "$(pct config "$VMID" 2>/dev/null)")

# Výstup výsledků
echo "ID posledního vytvořeného objektu: $VMID"
echo "MAC adresa: $MAC_ADDRESS"
if [ -n "$IP_ADDRESS" ]; then
  echo "IP adresa: $IP_ADDRESS"
else
  echo "IP adresa nebyla nalezena."
fi

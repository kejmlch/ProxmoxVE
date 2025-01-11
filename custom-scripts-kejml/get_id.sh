#!/bin/bash

# Získání ID naposledy vytvořeného objektu z logu
LOG_ENTRY=$(grep 'create' /var/log/pve/tasks/index | tail -n 1)
VMID=$(echo "$LOG_ENTRY" | grep -oP '\d+')

# Ověření, zda bylo ID úspěšně získáno
if [ -z "$VMID" ]; then
  echo "Nepodařilo se zjistit poslední vytvořené ID."
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

# Zjištění IP adresy (platí pouze pro kontejnery, pokud existuje IP nastavení)
IP_ADDRESS=$(grep -oP "ip=\K[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" <<< "$(pct config "$VMID" 2>/dev/null)")

# Výstup výsledků
echo "ID posledního vytvořeného objektu: $VMID"
echo "MAC adresa: $MAC_ADDRESS"
if [ -n "$IP_ADDRESS" ]; then
  echo "IP adresa: $IP_ADDRESS"
else
  echo "IP adresa nebyla nalezena."
fi

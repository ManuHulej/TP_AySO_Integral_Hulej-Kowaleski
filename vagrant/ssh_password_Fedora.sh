#!/bin/bash


SEARCH_PATTERN="^\s*#\?\s*PasswordAuthentication\s*no"
REPLACE_PATTERN="PasswordAuthentication yes"


sudo sed -i "s|$SEARCH_PATTERN|$REPLACE_PATTERN|g" /etc/ssh/sshd_config

# Buscar y reemplazar en archivos de configuración complementaria
if compgen -G "/etc/ssh/sshd_config.d/*.conf" > /dev/null; then
    for file in /etc/ssh/sshd_config.d/*.conf; do
        sudo sed -i "s|$SEARCH_PATTERN|$REPLACE_PATTERN|g" "$file"
    done
fi


if systemctl list-units --type=service | grep -q sshd.service; then
    sudo systemctl restart sshd
else
    sudo systemctl restart ssh
fi

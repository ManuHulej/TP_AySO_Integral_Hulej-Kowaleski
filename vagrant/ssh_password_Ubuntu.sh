#!/bin/bash


SEARCH_PATTERN="^\s*#\?\s*PasswordAuthentication\s*no"
REPLACE_PATTERN="PasswordAuthentication yes"


sudo sed -i "s|$SEARCH_PATTERN|$REPLACE_PATTERN|g" /etc/ssh/sshd_config


# Buscar y reemplazar en todos los archivos
if compgen -G "/etc/ssh/sshd_config.d/*.conf" > /dev/null; then
    for file in /etc/ssh/sshd_config.d/*.conf; do
        sudo sed -i "s|$SEARCH_PATTERN|$REPLACE_PATTERN|g" "$file"
    done
fi


sudo systemctl restart ssh

#!/bin/bash
clear

LISTA=$1
LOG_GENERAL="./logs/status_url.log"
ANT_IFS=$IFS
IFS=$'\n'


mkdir -p ./logs
mkdir -p /tmp/head-check/{ok,Error/{cliente,servidor}}

if [ ! -f "$LISTA" ]; then
  echo "Error: No se encontró el archivo $LISTA"
  exit 1
fi

echo "Iniciando chequeo de URLs en $LISTA ..."

for LINEA in $(grep -v '^#' "$LISTA"); do
  DOMINIO=$(echo "$LINEA" | awk '{print $1}')
  URL=$(echo "$LINEA" | awk '{print $2}')

  if [[ ! "$URL" =~ ^https?:// ]]; then
    URL="https://$URL"
  fi

  echo "Procesando dominio: $DOMINIO"
  echo "URL: $URL"

  STATUS_CODE=$(curl -LI -o /dev/null -w '%{http_code}\n' -s "$URL")

  echo "Código HTTP: $STATUS_CODE"

  TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

  echo "$TIMESTAMP - Code:$STATUS_CODE - $DOMINIO - URL:$URL" >> "$LOG_GENERAL"

  mkdir -p "./logs/$DOMINIO"
  echo "$TIMESTAMP - Code:$STATUS_CODE - URL:$URL" >> "./logs/$DOMINIO/status.log"

  if [ "$STATUS_CODE" -eq 200 ]; then
    echo "$TIMESTAMP - Code:$STATUS_CODE - URL:$URL" >> "/tmp/head-check/ok/$DOMINIO.log"
  elif [[ "$STATUS_CODE" -ge 400 && "$STATUS_CODE" -lt 500 ]]; then
    echo "$TIMESTAMP - Code:$STATUS_CODE - URL:$URL" >> "/tmp/head-check/Error/cliente/$DOMINIO.log"
  elif [[ "$STATUS_CODE" -ge 500 && "$STATUS_CODE" -lt 600 ]]; then
    echo "$TIMESTAMP - Code:$STATUS_CODE - URL:$URL" >> "/tmp/head-check/Error/servidor/$DOMINIO.log"
  fi

  echo "---------------------------------------"
done

IFS=$ANT_IFS

echo "Chequeo finalizado."


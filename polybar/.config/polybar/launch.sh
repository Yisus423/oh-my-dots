#!/bin/sh

# Matamos polybar (proceso previo)
pkill polybar

# Esperamos a que se termine de cerrar (matar) el proceso
# Reemplazamos $UID por $(id -u)
while pgrep -u "$(id -u)" -x polybar >/dev/null; do sleep 1; done
# Lanzamos la barra configurada (example) en segundo plano
polybar example &

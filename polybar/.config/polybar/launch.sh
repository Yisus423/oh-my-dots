#!/bin/bash

# Matamos polybar (proceso previo)
pkill polybar

# Esperamos a que se termine de cerrar (matar) el proceso
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Lanzamos la barra configurada (example) en segundo plano
polybar example &

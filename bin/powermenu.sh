#!/bin/bash

chosen=$(echo -e "󰐥 Apagar\n󰜉 Reiniciar\n󰤄 Suspender\n󰗼 Cerrar Sesión\n󰜺 Cancelar" | rofi -dmenu -i -p "Sistema:" -theme-str 'window {width: 15%;}')

case "$chosen" in
    "󰐥 Apagar") systemctl poweroff ;;
    "󰜉 Reiniciar") systemctl reboot ;;
    "󰤄 Suspender") systemctl suspend ;;
    "󰗼 Cerrar Sesión") i3-msg exit ;;
    *) exit 0
esac

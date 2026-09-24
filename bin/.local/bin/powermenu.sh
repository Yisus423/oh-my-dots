#!/bin/sh

options="󰐥 Apagar\n󰜉 Reiniciar\n󰤄 Suspender\n󰗼 Cerrar Sesión\n󰜺 Cancelar"

if [ -n "$WAYLAND_DISPLAY" ]; then
    chosen=$(printf '%b' "$options" | tofi --prompt-text "Sistema:" --width 20% --height 20%)
else
    chosen=$(printf '%b' "$options" | rofi -dmenu -i -p "Sistema:" -theme-str 'window {width: 15%;}')
fi

case "$chosen" in
    "󰐥 Apagar") systemctl poweroff ;;
    "󰜉 Reiniciar") systemctl reboot ;;
    "󰤄 Suspender") systemctl suspend ;;
    "󰗼 Cerrar Sesión")
        if [ -n "$WAYLAND_DISPLAY" ]; then
            swaymsg exit
        else
            i3-msg exit
        fi
        ;;
    *) exit 0
esac

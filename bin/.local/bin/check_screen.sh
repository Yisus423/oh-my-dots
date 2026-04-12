#!/bin/sh
# script para automatizar la verificación de hdmi en i3 wm
if xrandr | grep -q "HDMI-1 connected"; then
  autorandr --load tv_house
else
  autorandr --load mobile
fi

#!/bin/bash
#cree este script en bash para automatizar la verificación de hdmi en i3 wm
if xrandr | grep "HDMI-1 connected"; then
  autoarandr --load tv_house
else
  autoarandr --load mobile

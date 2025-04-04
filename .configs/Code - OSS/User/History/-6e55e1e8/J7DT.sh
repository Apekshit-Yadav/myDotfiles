#!/bin/bash

WALLPAPER=$(cat .cache/wal/wal)
wal -i $WALLPAPER -n -l
$HOME/HyprlandScripts/generate_hyprcolors.sh
$HOME/HyprlandScripts/hyprlockwalpath.sh
$HOME/HyprlandScripts/change_rofiwall7.sh
$HOME/HyprlandScripts/fuzzelcolors.sh

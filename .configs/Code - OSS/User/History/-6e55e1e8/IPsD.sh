#!/bin/bash
CURRMODE="dark"
WALLPAPER=$(cat .cache/wal/wal)
if [CURRMODE==dark] ;then 
    wal -i $WALLPAPER -n -l
    CURRMODE="light"
else
    wal -i $WALLPAPER -n
fi
$HOME/HyprlandScripts/generate_hyprcolors.sh
$HOME/HyprlandScripts/hyprlockwalpath.sh
$HOME/HyprlandScripts/change_rofiwall7.sh
$HOME/HyprlandScripts/fuzzelcolors.sh

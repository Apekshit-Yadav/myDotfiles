#!/bin/bash

# Get the current mode (fallback to Dark if missing)
MODE_FILE="$HOME/.cache/mode"
if [[ -f "$MODE_FILE" ]]; then
    CURRENT_MODE=$(cat "$MODE_FILE")
else
    CURRENT_MODE="Dark"
fi

# Rofi selection for mode
CHOICE=$(printf "Dark\nLight" | rofi -font "mono 16" -dmenu -p "Choose theme mode:")

# Exit if no choice made
[[ -z "$CHOICE" ]] && exit

# Get wallpaper from wal cache
WALLPAPER=$(cat "$HOME/.cache/wal/wal")

# Apply theme
if [[ "$CHOICE" == "Light" ]]; then
    wal -i "$WALLPAPER" -n -l
    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita"
    gsettings set org.gnome.desktop.interface color-scheme "prefer-light"
    echo "Light" > "$MODE_FILE"
else
    wal -i "$WALLPAPER" -n
    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
    gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
    echo "Dark" > "$MODE_FILE"
fi

# Reload waybar silently
pkill waybar && waybar > /dev/null 2>&1 &


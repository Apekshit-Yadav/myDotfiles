##!/bin/bash

# Directory containing wallpapers
WALLPAPER_DIR="$HOME/Pictures/Hyprpaper"

# Use Zenity to display a file chooser dialog
WALLPAPER=$(zenity --file-selection --title="Select a Wallpaper" \
  --filename="$WALLPAPER_DIR/" \
  --file-filter="*.png *.jpg *.jpeg" 2>/dev/null)

# Check if a wallpaper was selected
if [[ -z "$WALLPAPER" ]]; then
    notify-send "Pick a wallpaper, dummy!!!" --urgency=low --icon=dialog-warning
    exit 1
fi

# Mode cache file
CACHE_FILE="$HOME/.cache/mode"


# Apply the chosen mode and save to cache
    wal -i "$WALLPAPER" -n
    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
    gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
    echo "dark" > "$CACHE_FILE"

# Set wallpaper using swww
swww img "$WALLPAPER" --resize crop --transition-type any --transition-duration 1.5 --transition-fps 60

swaync-client --reload-css

## getting wallpaper to cache to get rofi image
cp $(cat ~/.cache/wal/wal) ~/.cache/currwall


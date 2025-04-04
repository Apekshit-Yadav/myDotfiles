#!/bin/bash

# Directory containing wallpapers
WALLPAPER_DIR="$HOME/Pictures/Hyprpaper"

# Select a random wallpaper
WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)

echo -e  "setting "$WALLPAPER" from "$WALLPAPER_DIR" \n"
# Set the wallpaper using swww
#swaybg -i "$WALLPAPER" -m fill &
WAYBARPOS=$(grep -oP '"position":\s*"\K(top|bottom)' "$HOME/.config/waybar/config.jsonc")

if [ "$WAYBARPOS" == "top" ]; then
  swww img "$WALLPAPER" --resize crop --transition-type outer --transition-duration 3.5 --transition-fps 60 --transition-pos 0.5,0.965 &
else
  swww img "$WALLPAPER" --resize crop --transition-type outer --transition-duration 3.5 --transition-fps 60 --transition-pos 0.5,0.035 &
fi

#setting dark mode
    NEW_MODE="Dark"
    wal -i "$WALLPAPER" -n
    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
    gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
    #sed -i 's/vim.cmd("colorscheme onelight")/vim.cmd("colorscheme onedark")/' "$HOME/.config/nvim/lua/plugins/onedark.lua"
    #sed -i "s/theme = 'onelight'/theme = 'onedark'/" "$HOME/.config/nvim/lua/plugins/lualine.lua"
    echo "$NEW_MODE" > "$HOME/.cache/mode"

## getting wallpaper to cache to get rofi image
cp $(cat ~/.cache/wal/wal) ~/.cache/currwall

# Call the color generation scripts
#$HOME/HyprlandScripts/generate_hyprcolors.sh
#$HOME/HyprlandScripts/hyprlockwalpath.sh
#$HOME/HyprlandScripts/change_rofiwall7.sh
#$HOME/HyprlandScripts/fuzzelcolors.sh
# not working - 
#$HOME/HyprlandScripts/update_wofi_colors.sh
#$HOME/HyprlandScripts/dunstcolorsupdater.sh
#$HOME/HyprlandScripts/updatemakocolors.sh
#$HOME/HyprlandScripts/logoutmenucolorschanger.sh

swaync-client --reload-css

# Reload kitty with new colors
#kitty @ set-colors --all ~/.cache/wal/colors-kitty.conf

#magick -size 1920x1080 xc:transparent /home/papa/Pictures/Hyprpaper/transparent.png

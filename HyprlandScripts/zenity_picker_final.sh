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

# Prompt user for mode selection using Rofi
CHOICE=$(echo -e "Dark\nLight" | rofi -dmenu -i -p "Select Mode" -config "$HOME/testconfigs/rofidark.rasi" -font "mono 18")

# Apply the chosen mode and save to cache
if [[ "$CHOICE" == "Dark" ]]; then
    wal -i "$WALLPAPER" -n
    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
    gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
    echo "dark" > "$CACHE_FILE"
    #sed -i 's/vim.cmd("colorscheme onelight")/vim.cmd("colorscheme onedark")/' "$HOME/.config/nvim/lua/plugins/onedark.lua"
    #sed -i "s/theme = 'onelight'/theme = 'onedark'/" "$HOME/.config/nvim/lua/plugins/lualine.lua"
elif [[ "$CHOICE" == "Light" ]]; then
    wal -i "$WALLPAPER" -n -l
    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita"
    gsettings set org.gnome.desktop.interface color-scheme "prefer-light"
    echo "light" > "$CACHE_FILE"
    #sed -i 's/vim.cmd("colorscheme onedark")/vim.cmd("colorscheme onelight")/' "$HOME/.config/nvim/lua/plugins/onedark.lua"
    #sed -i "s/theme = 'onedark'/theme = 'onelight'/" "$HOME/.config/nvim/lua/plugins/lualine.lua"
else
    echo "No valid choice selected, exiting..."
    exit 1
fi

# Reload Neovim to apply changes
#nvim --headless +"Lazy reload onedarkpro.nvim" +q
#nvim --headless +"Lazy reload lualine.nvim" +q

# Set wallpaper using swww
swww img "$WALLPAPER" --resize crop --transition-type grow --transition-duration 1.5 --transition-fps 60 --transition-pos 0.5,0.96 &

# Update Rofi background
#sed -i "s|background-image: url.*|background-image: url(\"$WALLPAPER\",width);|" ~/.config/rofi/coloredrofidark.rasi

# Call the color generation scripts
#$HOME/HyprlandScripts/generate_hyprcolors.sh
#$HOME/HyprlandScripts/hyprlockwalpath.sh
#$HOME/HyprlandScripts/change_rofiwall7.sh
#$HOME/HyprlandScripts/fuzzelcolors.sh

swaync-client --reload-css

## getting wallpaper to cache to get rofi image
cp $(cat ~/.cache/wal/wal) ~/.cache/currwall

# Reload kitty with new colors
#kitty @ set-colors --all ~/.cache/wal/colors-kitty.conf

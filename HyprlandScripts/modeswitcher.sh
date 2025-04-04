#!/bin/bash

# Get the last mode from cache file (or default to Dark)
MODE_FILE="$HOME/.cache/mode"
if [[ -f "$MODE_FILE" ]]; then
    CURRENT_MODE=$(cat "$MODE_FILE")
else
    CURRENT_MODE="Dark"
fi

# Get the last wallpaper from pywal cache
WALLPAPER=$(cat "$HOME/.cache/wal/wal")

# Toggle between Light and Dark
if [[ "$CURRENT_MODE" == "Dark" ]]; then
    NEW_MODE="Light"
    wal -i "$WALLPAPER" -n -l
    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita"
    gsettings set org.gnome.desktop.interface color-scheme "prefer-light"
#    sed -i 's/vim.cmd("colorscheme onedark")/vim.cmd("colorscheme onelight")/' "$HOME/.config/nvim/lua/plugins/onedark.lua"
#    sed -i "s/theme = 'onedark'/theme = 'onelight'/" "$HOME/.config/nvim/lua/plugins/lualine.lua"
    killall waybar && waybar -s .config/waybar/stylelight.css &
else
    NEW_MODE="Dark"
    wal -i "$WALLPAPER" -n
    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
    gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
#    sed -i 's/vim.cmd("colorscheme onelight")/vim.cmd("colorscheme onedark")/' "$HOME/.config/nvim/lua/plugins/onedark.lua"
#    sed -i "s/theme = 'onelight'/theme = 'onedark'/" "$HOME/.config/nvim/lua/plugins/lualine.lua"
    killall waybar && waybar &
fi

# Save the new mode
echo "$NEW_MODE" > "$MODE_FILE"

# Reload Neovim colors
nvim --headless +"Lazy reload onedarkpro.nvim" +q
nvim --headless +"Lazy reload lualine.nvim" +q

# Run additional scripts
$HOME/HyprlandScripts/generate_hyprcolors.sh
$HOME/HyprlandScripts/hyprlockwalpath.sh
$HOME/HyprlandScripts/change_rofiwall7.sh
$HOME/HyprlandScripts/fuzzelcolors.sh

# Reload notification styles
swaync-client --reload-css


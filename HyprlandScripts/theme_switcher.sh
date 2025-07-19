#!/bin/bash

THEME_DIR="$HOME/.config/themes"
ACTIVE_LINK="$THEME_DIR/active"
DEFAULT_HYTHEME="$THEME_DIR/default/hytheme.conf"

entries=""

# Collect all valid themes with their preview PNG
for dir in "$THEME_DIR"/*/; do
    theme=$(basename "$dir")

    # Skip special folders
    [[ "$theme" == "active" || "$theme" == "default" ]] && continue

    preview="$THEME_DIR/$theme.png"

    if [[ -f "$preview" ]]; then
        entries+="${theme}\x00icon\x1f${preview}\n"
    else
        entries+="${theme}\n"  # fallback: text only
    fi
done

# Show Rofi with preview icons
#CHOICE=$(printf "$entries" | rofi -dmenu -config ~/HyprlandScripts/moder.rasi -p "🎨 Select Theme:" -show-icons)
CHOICE=$(printf "$entries" | rofi -dmenu -config ~/testconfigs/thewe.rasi -p "🎨 Select Theme:" -show-icons)

# If nothing chosen, exit
[[ -z "$CHOICE" ]] && exit 0

SELECTED="$THEME_DIR/$CHOICE"

# Switch active theme symlink
rm -rf "$ACTIVE_LINK"
ln -s "$SELECTED" "$ACTIVE_LINK"

# If no hytheme.conf in theme, symlink default one
[[ ! -f "$ACTIVE_LINK/hytheme.conf" && -f "$DEFAULT_HYTHEME" ]] && \
    ln -sf "$DEFAULT_HYTHEME" "$ACTIVE_LINK/hytheme.conf"

# Wait until wallpapers dir appears
for i in {1..20}; do
    [[ -d "$ACTIVE_LINK/wallpapers" ]] && break
    sleep 0.05
done

# Apply theme (wallpaper, pywal, preview update, etc.)
~/HyprlandScripts/change_wallpaper_final.sh

# Reload Hyprland just in case
hyprctl reload

notify-send "🎨 Theme switched to '$CHOICE'"

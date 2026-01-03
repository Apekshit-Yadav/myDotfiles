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
CHOICE=$(printf "$entries" | rofi -i -dmenu -config ~/HyprlandScripts/rofi_themer.rasi -p "🎨 Select Theme:" -show-icons)
#CHOICE=$(printf "$entries" | rofi -dmenu -config ~/HyprlandScripts/theme_change.rasi -p "🎨 Select Theme:" -show-icons)
#CHOICE=$(printf "$entries" | rofi -dmenu -config ~/testconfigs/thewe.rasi -p "🎨 Select Theme:" -show-icons)

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


# Attempt to restore last-used wallpaper
WALLPAPER_DIR="$ACTIVE_LINK/wallpapers"
CURR_WALL=$(find "$WALLPAPER_DIR" -maxdepth 1 -type l -name "current" | head -n 1)

if [[ -n "$CURR_WALL" && -f "$CURR_WALL" ]]; then
    echo "🖼️ Restoring wallpaper from $CURR_WALL"
    swww img "$CURR_WALL" --resize crop \
        --transition-type wipe \
        --transition-duration 2.5 \
        --transition-fps 60 \
        --transition-angle 135
    #wal -i "$CURR_WALL" -n
#    wal -i "$(readlink .config/themes/active/wallpapers/current)" -n
# Lowercase the choice for case-insensitive matching
CHOICE_LOWER=$(echo "$CHOICE" | tr '[:upper:]' '[:lower:]')

case "$CHOICE_LOWER" in
    mono)
        wal -i "$(readlink .config/themes/active/wallpapers/current)" -n -b 000000
        ;;
    # Add more lowercase theme keys here in the future
    *)
        wal -i "$(readlink .config/themes/active/wallpapers/current)" -n
        ;;
esac


    
    ln -sf "$ACTIVE_LINK/wallpapers/$(basename $(readlink $CURR_WALL))" ~/.cache/currwall
    ln -sf "$ACTIVE_LINK/wallpapers/$(basename $(readlink $CURR_WALL))" ~/.cache/currwall.png
    swaync-client --reload-css   
else
    echo "⚠️  No current wallpaper symlink found in $WALLPAPER_DIR"
    # Uncomment this if you want fallback behavior:
     ~/HyprlandScripts/change_wallpaper_final.sh
fi

# Apply theme (wallpaper, pywal, preview update, etc.)
#~/HyprlandScripts/change_wallpaper_final.sh

# Reload Hyprland just in case
hyprctl reload

notify-send "🎨 Theme switched to '$CHOICE'"

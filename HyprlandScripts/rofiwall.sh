#!/bin/bash

WALLPAPER_DIR="$HOME/.config/themes/active/wallpapers"
PREVIEW_DIR="$HOME/.cache/wallimg"

mkdir -p "$PREVIEW_DIR"

# Pick correct ImageMagick command (IM7=magick, IM6=convert)
if command -v magick >/dev/null 2>&1; then
    IM_CMD="magick"
else
    IM_CMD="convert"
fi

entries=""

# Collect wallpapers and make previews
for wp in "$WALLPAPER_DIR"/*.{jpg,jpeg,png}; do
    [[ -f "$wp" ]] || continue

    name=$(basename "$wp")
    preview="$PREVIEW_DIR/$name.png"

    # Generate preview if not exists
    if [[ ! -f "$preview" ]]; then
        $IM_CMD "$wp" -resize 300x300^ -gravity center -extent 300x300 "$preview"
    fi

    entries+="${name}\x00icon\x1f${preview}\n"
done

# Show rofi with previews
CHOICE=$(printf "$entries" | rofi -i -dmenu -config ~/HyprlandScripts/rofi_themer.rasi -p "🖼 Wallpaper:" -show-icons)
#CHOICE=$(printf "$entries" | rofi -dmenu -config ~/HyprlandScripts/theme_change.rasi -p "🖼 Wallpaper:" -show-icons)

# Exit if nothing chosen
[[ -z "$CHOICE" ]] && exit 0

WALLPAPER="$WALLPAPER_DIR/$CHOICE"

# Set wallpaper via swww (random transition position is default)
swww img "$WALLPAPER" --resize crop \
  --transition-type outer \
  --transition-duration 2.5 \
  --transition-fps 60

# Generate colors with pywal
wal -i "$WALLPAPER" -n

# Symlink current wallpaper for other tools
ln -sf "$WALLPAPER" ~/.cache/currwall
ln -sf "$WALLPAPER" ~/.cache/currwall.png

# Reload UI components
swaync-client --reload-css

# === Auto-generate theme preview ===
ACTIVE_THEME_DIR="$HOME/.config/themes/active"
ACTIVE_THEME_NAME=$(basename "$(readlink "$ACTIVE_THEME_DIR")")
PREVIEW_PATH="$HOME/.config/themes/${ACTIVE_THEME_NAME}.png"

# Resolve real theme folder from symlink
THEME_DIR="$(readlink -f "$ACTIVE_THEME_DIR")"
WALL_NAME="$(basename "$WALLPAPER")"
TARGET_WALL="$THEME_DIR/wallpapers/$WALL_NAME"
SYMLINK_PATH="$THEME_DIR/wallpapers/current"

# Symlink current wallpaper inside theme folder
if [[ -f "$TARGET_WALL" ]]; then
    ln -sf "$TARGET_WALL" "$SYMLINK_PATH"
    echo "🪄 Symlinked current → $WALL_NAME"
else
    echo "⚠️ Wallpaper $WALL_NAME not found in $THEME_DIR/wallpapers/"
fi

# Generate/update theme preview
if [[ -f "$WALLPAPER" ]]; then
    $IM_CMD "$WALLPAPER" -resize 300x300^ -gravity center -extent 300x300 "$PREVIEW_PATH"
    echo "🖼️ Generated preview: $PREVIEW_PATH"
fi

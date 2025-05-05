#!/bin/bash

# Paths
WALL="$(cat ~/.cache/wal/wal)"
MODE="$(cat ~/.cache/mode)"  # 'light' or 'dark'

# Available styles
styles=("default" "pastel" "rich" "vivid" "storm" "washed")

# Rofi prompt for style
STYLE=$(printf "%s\n" "${styles[@]}" | rofi -config ~/HyprlandScripts/thewe.rasi -dmenu -p "Select color variant:")

# Exit if no selection made
[ -z "$STYLE" ] && exit

# Set variant-specific settings based on selected style
case "$STYLE" in
    pastel)
        SAT=0.5
        CON=1.1
        BACKEND="modern_ColorThief"
        ;;
    rich)
        SAT=1.6
        CON=1.3
        BACKEND="haishoku"
        ;;
    vivid)
        SAT=2.0
        CON=1.5
        BACKEND="fast_ColorThief"
        ;;
    storm)
        SAT=0.9
        CON=1.8
        BACKEND="modern_ColorThief"
        ;;
    washed)
        SAT=0.3
        CON=0.8
        BACKEND="colorz"
        ;;
    *)
        # Default style: no saturation or contrast
        SAT=""
        CON=""
        BACKEND="wal"
        ;;
esac

# Construct wal command
WAL_CMD=(wal -i "$WALL" -n --backend "$BACKEND")
[[ "$MODE" == "Light" ]] && WAL_CMD+=("-l")
[[ -n "$SAT" ]] && WAL_CMD+=("--saturate" "$SAT")
[[ -n "$CON" ]] && WAL_CMD+=("--contrast" "$CON")

# Apply theme
"${WAL_CMD[@]}"

# Update Rofi theme import line based on mode
sed -i "s|@import \".*colors-rofi-.*\.rasi\"|@import \"~/.cache/wal/colors-rofi-${MODE,,}.rasi\"|" "$HOME/.config/rofi/myconfig.rasi"

# Reload waybar quietly
pkill waybar && waybar > /dev/null 2>&1 &

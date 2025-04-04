#!/bin/bash

CONFIG_FILE=$HOME/.config/waybar/config.jsonc

# Get current position
CURRENT_POS=$(grep -oP '"position":\s*"\K(top|bottom)' "$CONFIG_FILE")

# Toggle between top and bottom
if [[ "$CURRENT_POS" == "top" ]]; then
    NEW_POS="bottom"
else
    NEW_POS="top"
fi

# Modify the config file
sed -i -E "s/(\"position\":[[:space:]]*\")([a-zA-Z]+)(\")/\1$NEW_POS\3/" "$CONFIG_FILE"

# Restart Waybar to apply changes
pkill -SIGUSR2 waybar

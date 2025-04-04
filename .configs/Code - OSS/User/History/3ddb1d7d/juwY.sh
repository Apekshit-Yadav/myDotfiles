#!/bin/bash

# Configuration
NOTIFY_CMD="notify-send"
BRIGHTNESS_TOOL="brightnessctl"
NOTIFY_ID=9998  # Unique ID for replacing notifications
FACTOR=1.15  # Exponential growth factor

# Get current brightness percentage
get_brightness() {
    brightness=$($BRIGHTNESS_TOOL get)
    max_brightness=$($BRIGHTNESS_TOOL max)
    echo $((brightness * 100 / max_brightness))  # Convert to percentage
}

# Set brightness (accepts percentage)
set_brightness() {
    local new_brightness=$1
    $BRIGHTNESS_TOOL set "${new_brightness}%"
}

# Ensure brightness stays between 0% and 100%
clamp_brightness() {
    local brightness=$1
    if (( brightness > 100 )); then
        echo 100
    elif (( brightness < 0 )); then
        echo 0
    else
        echo "$brightness"
    fi
}

# Adjust brightness with hybrid exponential & linear scaling
adjust_brightness() {
    local change=$1
    local current_brightness=$(get_brightness)

    if (( current_brightness == 0 && change > 0 )); then
        new_brightness=1  # If at 0%, set to 1% to prevent getting stuck
    elif (( current_brightness <= 6 && change > 0 )); then
        new_brightness=$((current_brightness + 1))  # Linear +1% for low brightness
    elif (( current_brightness > 6 && change > 0 )); then
        new_brightness=$(awk "BEGIN {print int($current_brightness * $FACTOR)}")  # Exponential increase
    elif (( current_brightness > 6 && change < 0 )); then
        new_brightness=$(awk "BEGIN {print int($current_brightness / $FACTOR)}")  # Exponential decrease
    else
        new_brightness=$((current_brightness - 1))  # Linear -1% for low brightness
    fi

    new_brightness=$(clamp_brightness "$new_brightness")
    set_brightness "$new_brightness"
}

# Show a progressive brightness notification
show_notification() {
    local brightness=$(get_brightness)
    $NOTIFY_CMD -r $NOTIFY_ID -h int:value:$brightness -h string:synchronous:brightness \
        -i display-brightness "Brightness: $brightness%"
}

# Main functionality
case "$1" in
    up)
        adjust_brightness 1
        show_notification
        ;;
    down)
        adjust_brightness -1
        show_notification
        ;;
    *)
        show_notification
        ;;
esac

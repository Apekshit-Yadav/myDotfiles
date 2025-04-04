#!/bin/bash

# Configuration
NOTIFY_CMD="notify-send"
BRIGHTNESS_TOOL="brightnessctl"
NOTIFY_ID=9998  # Unique ID for replacing notifications

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

# Adjust brightness with corrected step logic
adjust_brightness() {
    local change=$1
    local current_brightness=$(get_brightness)

    # Handle step logic
    if (( change > 0 )); then  # Increasing brightness
        step=$(( current_brightness >= 11 ? 5 : 1 ))
    else  # Decreasing brightness
        if (( current_brightness > 11 )); then
            step=5
        elif (( current_brightness == 11 )); then
            step=1  # Go to 10% before using 1% steps
        else
            step=1
        fi
    fi

    local new_brightness=$((current_brightness + (change * step)))
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

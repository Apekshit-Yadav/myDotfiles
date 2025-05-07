#!/bin/bash

# Define the available power profiles
options="Performance\nBalanced\nPower-Saver"

# Use rofi to display the options
chosen=$(echo -e "$options" | rofi -dmenu -p "Select Power Profile" -i -config ~/HyprlandScripts/thewe.rasi)

# Set the selected power profile
case "$chosen" in
  "Performance")
    echo "Setting power profile to: Performance"
    powerprofilesctl set performance
    ;;
  "Balanced")
    echo "Setting power profile to: Balanced"
    powerprofilesctl set balanced
    ;;
  "Power-Saver")
    echo "Setting power profile to: Power-Saver"
    powerprofilesctl set power-saver
    ;;
  *)
    echo "Invalid option. Exiting."
    exit 1
    ;;
esac

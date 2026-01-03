#! /bin/bash

eval "$(dbus-launch --sh-syntax --exit-with-session)"
systemctl --user import-environment DISPLAY XAUTHORITY DBUS_SESSION_BUS_ADDRESS XDG_RUNTIME_DIR
# 1. Polkit (Authentication Agent) - Essential for GUI password prompts
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

# 2. Gnome Keyring (Secrets/Passwords)
#eval $(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
#export SSH_AUTH_SOCK

# 3. System Tray & Network
#nm-applet &
#blueman-applet &

# 4. Visuals (Picom, Wallpaper)
picom -b --config ~/.config/picom/picomOpaq.conf &
~/X11Scripts/wallpaper.sh & 

# 5. Status Bar
# If you use a script for the bar, run it here:
# ~/X11Scripts/status_bar.sh &


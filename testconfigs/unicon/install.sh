!/bin/env bash

##this script is to install my dotfiles

######## Basic Packages ###########

### Check for aurhelper (still to implement)  ###

sudo pacman -S --needed base-devel git
sudo pacman -Syu 

## installing yay ##
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
echo $(yay --version)

## installing necessary packages ##
yay -S --no-confirm --needed hyprland hyprlock hyprsunset rofi waybar wlogout dunst fuzzel git kitty pywal zenity

## install fonts ##
sudo pacman -S --no-confirm --needed ttf-fira-mono ttf-jetbrains-mono ttf-font-awesome nerd-fonts

## installing some apps and required things 
## (you can add yours here) ##
yay -S --needed  brave-bin hyprpolkitagent ly gparted lxappearance qt6ct qt5ct





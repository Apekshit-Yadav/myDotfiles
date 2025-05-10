#!/usr/bin/env bash

# Colors
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
NC="\033[0m" # No Color

# Dotfiles repository URL
DOTFILES_REPO="https://github.com/Apekshit-Yadav/myDotfiles.git"

# Package arrays
pacman_packages=(
  git
  rofi-wayland
  swww
  waybar
  hyprland
  hyprlock
  hypridle
  fuzzel
  swaync
  neovim
  kitty
  eog
  alacritty
  htop
  btop
  bluez
  blueman
  cava
  cliphist
  cmatrix
  fastfetch
  file-roller
  gparted
  nautilus
  pcmanfm
  ly
  zenity
  udiskie
  wl-clipboard
  network-manager-applet
  nwg-look
  orchis-theme
  xdg-desktop-portal
  xdg-desktop-portal-gtk
  xdg-desktop-portal-hyprland
  xorg-xhost
  go
)

aur_packages=(
  otf-hermit-nerd
  ttf-dejavu-nerd
  ttf-firacode-nerd
  ttf-heavydata-nerd
  ttf-jetbrains-mono-nerd
  hyprpolkitagent
  kora-icon-theme
  wlogout
  auto-cpufreq
  brightnessctl
  brave-bin
  pywal
  zathura
  zathura-pdf-poppler
  zathura-pywal-git
)

optional_packages=(
  telegram-desktop
  code
  ranger
  github-desktop
)

# Function to ask and optionally run Timeshift backup
run_backup() {
  read -rp "Do you want to create a Timeshift backup before proceeding? [y/N]: " confirm
  if [[ $confirm =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Creating Timeshift backup...${NC}"
    yay -S --noconfirm timeshift
    sudo timeshift --create --comments "before installing dotfiles"
  else
    echo -e "${YELLOW}Skipping Timeshift backup.${NC}"
  fi
}

# Function to install Pacman packages
install_pacman_packages() {
  echo -e "${YELLOW}Installing Pacman packages...${NC}"
  for pkg in "${pacman_packages[@]}"; do
    if ! pacman -Qi "$pkg" &>/dev/null; then
      echo -e "Installing $pkg..."
      sudo pacman -S --noconfirm --needed "$pkg"
    else
      echo -e "$pkg is already installed."
    fi
  done
}

# Function to install AUR packages using yay
install_aur_packages() {
  if ! command -v yay &>/dev/null && ! command -v paru &>/dev/null; then
    echo -e "${YELLOW}No AUR helper found (yay or paru). Please install one to continue.${NC}"
    exit 1
  fi

  aur_helper=$(command -v yay || command -v paru)

  echo -e "${YELLOW}Installing AUR packages with $aur_helper...${NC}"
  for pkg in "${aur_packages[@]}"; do
    if ! pacman -Qi "$pkg" &>/dev/null; then
      "$aur_helper" -S --noconfirm "$pkg"
    else
      echo -e "$pkg is already installed."
    fi
  done
}

# Function to install optional packages
install_optional_packages() {
  for pkg in "${optional_packages[@]}"; do
    read -rp "Do you want to install optional package $pkg? [y/N]: " answer
    if [[ $answer =~ ^[Yy]$ ]]; then
      yay -S --noconfirm "$pkg"
    else
      echo -e "Skipping $pkg."
    fi
  done
}

# Function to clone the dotfiles repository and copy to home
clone_dotfiles() {
  if [ -d "$HOME/myDotfiles" ]; then
    echo -e "${YELLOW}Dotfiles directory already exists. Skipping clone.${NC}"
  else
    echo -e "${YELLOW}Cloning dotfiles repository to home directory...${NC}"
    git clone "$DOTFILES_REPO" "$HOME/myDotfiles"
  fi

  echo -e "${YELLOW}Copying dotfiles to home directory...${NC}"
  cp -rf "$HOME/myDotfiles/." "$HOME/"

  echo -e "${GREEN}Dotfiles cloned and copied to home directory successfully!${NC}"

  # Make all scripts in HyprlandScripts executable
  chmod +x "$HOME/HyprlandScripts"/*
}

# Function to install zsh, Oh My Zsh, Powerlevel10k, and plugins
install_zsh_and_p10k() {
  if ! pacman -Qi zsh &>/dev/null; then
    echo -e "${YELLOW}Installing zsh...${NC}"
    sudo pacman -S --noconfirm --needed zsh
  else
    echo -e "${YELLOW}zsh is already installed.${NC}"
  fi

  ZSH_PATH=$(which zsh)
  if ! grep -q "$ZSH_PATH" /etc/shells; then
    echo -e "${YELLOW}Adding $ZSH_PATH to /etc/shells...${NC}"
    echo "$ZSH_PATH" | sudo tee -a /etc/shells
  fi

  if [[ "$SHELL" != "$ZSH_PATH" ]]; then
    echo -e "${YELLOW}Setting zsh as the default shell...${NC}"
    sudo chsh -s "$ZSH_PATH" "$USER"
  fi

  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${YELLOW}Installing Oh My Zsh...${NC}"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  else
    echo -e "${YELLOW}Oh My Zsh is already installed.${NC}"
  fi

  if [ ! -f /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme ]; then
    echo -e "${YELLOW}Installing Powerlevel10k theme from AUR...${NC}"
    yay -S --noconfirm zsh-theme-powerlevel10k-git
  else
    echo -e "${YELLOW}Powerlevel10k theme is already installed.${NC}"
  fi

  if ! grep -q "powerlevel10k.zsh-theme" "$HOME/.zshrc"; then
    echo 'source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme' >> "$HOME/.zshrc"
  fi

  if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    echo -e "${YELLOW}Installing zsh-autosuggestions...${NC}"
    git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
  fi

  if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
    echo -e "${YELLOW}Installing zsh-syntax-highlighting...${NC}"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
  fi

  echo -e "${GREEN}zsh, Oh My Zsh, Powerlevel10k, and plugins installed successfully!${NC}"
}

enable_ly_displaymanager() {
  read -rp "Do you want to enable LY display manager and disable the current one? [Y/n]: " choice
  choice=${choice,,}  # convert to lowercase
  if [[ -z "$choice" || $choice == "y" || $choice == "yes" ]]; then
    current_dm=$(readlink -f /etc/systemd/system/display-manager.service | xargs basename)
    if [[ $current_dm != "ly.service" ]]; then
      echo -e "${YELLOW}Disabling current display manager: $current_dm...${NC}"
      sudo systemctl disable "$current_dm"
    fi
    echo -e "${YELLOW}Enabling ly display manager...${NC}"
    sudo systemctl enable ly.service
  else
    echo -e "${GREEN}Skipped changing display manager.${NC}"
  fi
}

## setting up orchis theme and dark mode ##
echo -e "${GREEN} setting up dark orchis theme"
gsettings set org.gnome.desktop.interface gtk-theme 'orchis-dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'


##   Run all setup steps   ##
run_backup
install_pacman_packages
install_aur_packages
install_optional_packages
clone_dotfiles
install_zsh_and_p10k
enable_ly_displaymanager

echo -e "${GREEN}All tasks completed!${NC}"

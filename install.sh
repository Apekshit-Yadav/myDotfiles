#!/usr/bin/env bash

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Set package directory (relative to this script)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
PKG_DIR="$SCRIPT_DIR/packages"
pacman_file="$PKG_DIR/pacman.txt"
aur_file="$PKG_DIR/aur.txt"
optional_file="$PKG_DIR/optional.txt"

# Function: Backup existing dotfiles
run_backup() {
  read -rp "Do you want to back up existing dotfiles before proceeding? [y/N]: " confirm
  confirm=${confirm,,}  # lowercase the input

  if [[ "$confirm" =~ ^(y|yes)$ ]]; then
    echo -e "${YELLOW}Backing up existing dotfiles...${NC}"
    BACKUP_DIR="$HOME/Backups/.dotfiles_backup_$(date +%s)"
    mkdir -p "$BACKUP_DIR"
    cp -r "$HOME/.config" "$BACKUP_DIR" 2>/dev/null || true
    echo -e "${GREEN}Backup created at $BACKUP_DIR${NC}"
  else
    echo -e "${YELLOW}Skipping backup as per user input.${NC}"
  fi
}

# Function: Clone dotfiles repository
clone_dotfiles() {
  DOTFILES_REPO="https://github.com/Apekshit-Yadav/myDotfiles.git"
  DOTFILES_DIR="$HOME/myDotfiles"

  if [[ -d "$DOTFILES_DIR" ]]; then
    echo -e "${YELLOW}Directory '$DOTFILES_DIR' already exists.${NC}"
    read -rp "Do you want to remove it and re-clone the repo? [y/N]: " answer
    answer=${answer,,}
    if [[ "$answer" =~ ^(y|yes)$ ]]; then
      rm -rf "$DOTFILES_DIR"
      echo -e "${YELLOW}Old dotfiles directory removed.${NC}"
    else
      echo -e "${YELLOW}Skipping cloning. Using existing dotfiles at '$DOTFILES_DIR'.${NC}"
      return
    fi
  fi

  echo -e "${YELLOW}Cloning dotfiles repository into '$DOTFILES_DIR'...${NC}"
  if git clone --depth=1 "$DOTFILES_REPO" "$DOTFILES_DIR"; then
    echo -e "${GREEN}Dotfiles repo cloned successfully!${NC}"
  else
    echo -e "${YELLOW}Failed to clone the repository. Exiting.${NC}"
    exit 1
  fi
}

# Function: Sync dotfiles to home directory
link_dotfiles_to_home() {
  echo -e "${YELLOW}Linking dotfiles to home directory...${NC}"
  rsync -avh --no-perms \
    --exclude ".git/" \
    --exclude "install.sh" \
    --exclude "packages/" \
    "$HOME/myDotfiles/" "$HOME/"

  # Ensure HyprlandScripts are executable
  chmod +x "$HOME/HyprlandScripts"/* 2>/dev/null || true
}

# Function: Install pacman packages from file
install_pacman_packages() {
  echo -e "${YELLOW}Installing Pacman packages...${NC}"
  if [[ -f "$pacman_file" ]]; then
    grep -vE '^[[:space:]]*#|^[[:space:]]*$' "$pacman_file" | \
      xargs -r -d '\n' -I {} bash -c '
        if ! pacman -Qi {} &>/dev/null; then
          echo -e "Installing {}..."
          sudo pacman -S --noconfirm --needed {}
        else
          echo -e "{} is already installed."
        fi
      '
  else
    echo -e "${YELLOW}Pacman package list not found at $pacman_file${NC}"
  fi
}

# Function: Install AUR helper if missing, then install AUR packages from file
install_aur_packages() {
  if ! command -v yay &>/dev/null && ! command -v paru &>/dev/null; then
    echo -e "${YELLOW}No AUR helper found. Install yay or paru? (yay/paru) [yay]: ${NC}"
    read -r aur_choice
    aur_choice=${aur_choice,,}
    aur_choice=${aur_choice:-yay}

    sudo pacman -S --needed --noconfirm git base-devel
    tmpdir=$(mktemp -d)
    git clone "https://aur.archlinux.org/${aur_choice}.git" "$tmpdir/$aur_choice"
    (cd "$tmpdir/$aur_choice" && makepkg -si --noconfirm)
    rm -rf "$tmpdir"
  fi

  aur_helper=$(command -v yay || command -v paru)

  echo -e "${YELLOW}Installing AUR packages with $aur_helper...${NC}"
  if [[ -f "$aur_file" ]]; then
    grep -vE '^[[:space:]]*#|^[[:space:]]*$' "$aur_file" | \
      xargs -r -d '\n' -I {} bash -c '
        if ! pacman -Qi {} &>/dev/null; then
          echo -e "Installing {} from AUR..."
          '"$aur_helper"' -S --noconfirm {}
        else
          echo -e "{} is already installed."
        fi
      '
  else
    echo -e "${YELLOW}AUR package list not found at $aur_file${NC}"
  fi
}

# Function: Install optional packages interactively
install_optional_packages() {
  if [[ -f "$optional_file" ]]; then
    while IFS= read -r pkg; do
      [[ "$pkg" =~ ^[[:space:]]*#.*$ || -z "$pkg" ]] && continue
      read -rp "Do you want to install optional package $pkg? [y/N]: " answer
      if [[ $answer =~ ^[Yy]$ ]]; then
        "$aur_helper" -S --noconfirm "$pkg"
      else
        echo -e "Skipping $pkg."
      fi
    done < "$optional_file"
  else
    echo -e "${YELLOW}Optional package list not found at $optional_file${NC}"
  fi
}

# Function: Install ZSH and Powerlevel10k
install_zsh_and_p10k() {
  echo -e "${YELLOW}Installing Zsh and Powerlevel10k...${NC}"
  sudo pacman -S --noconfirm --needed zsh
  chsh -s /bin/zsh "$USER"

  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi

  if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
      "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
  fi
  echo -e "${GREEN}ZSH and Powerlevel10k installed.${NC}"
}

# Function: Enable LY Display Manager
enable_ly_displaymanager() {
  echo -e "${YELLOW}Enabling LY Display Manager...${NC}"
  sudo systemctl enable ly.service
  sudo systemctl set-default graphical.target
}

after_install() {
  echo -e "${YELLOW}Running post-install steps...${NC}"

  # 1. Run theme switcher script if it exists and is executable
  if [[ -x "$HOME/HyprlandScripts/theme_switcher.sh" ]]; then
    echo -e "Launching theme switcher..."
    "$HOME/HyprlandScripts/theme_switcher.sh"
  else
    echo -e "${YELLOW}theme_switcher.sh not found or not executable.${NC}"
  fi

  # 2. Symlink waybar colors from pywal cache
  ln -sf "$HOME/.cache/wal/colors-waybar.css" "$HOME/.config/waybar/colors-waybar.css"

  # 3. Symlink to wlogout (note: fix typo in 'olors.css' to 'colors.css' if needed)
  ln -sf "$HOME/.config/waybar/colors-waybar.css" "$HOME/.config/wlogout/colors.css"

  echo -e "${GREEN}Post-install configuration complete.${NC}"
}

# Main execution
run_backup
clone_dotfiles
link_dotfiles_to_home
install_pacman_packages
install_aur_packages
install_optional_packages
install_zsh_and_p10k
enable_ly_displaymanager
after_install

echo -e "${GREEN}All packages and system setup complete. Dotfiles are ready!${NC}"

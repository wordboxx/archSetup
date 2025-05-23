#!/bin/bash

update_system() {
  # Update the system
  echo "Updating the system..."
  sudo pacman -Syu || {
    echo "Failed to update the system. Please check your internet connection."
    exit 1
  }
}

is_arch_based() {
  # Checks if the system is Arch-based
  if grep -q '^ID_LIKE=*arch*' /etc/os-release; then
    echo "Arch-based distribution detected."
    return 0
  else
    echo "This script is intended for Arch-based distributions only."
    return 1
  fi
}

install_packages_pacman() {
  # Install packages using pacman
  local packages=()

  # Gets packages from file
  while read -r pkg; do
    packages+=("$pkg")
  done <"packages_pacman.txt"

  # Loops through packages array
  # If package is not installed, add it to missing array
  for pkg in "${packages[@]}"; do
    if ! pacman -Qi "$pkg" &>/dev/null; then
      sudo pacman -S "$pkg" || {
        echo "Failed to install $pkg. Please check the package name or your internet connection."
        exit 1
      }
    else
      echo "$pkg is already installed."
    fi
  done
}

install_packages_flatpak() {
  # Install packages using flatpak
  local packages=()

  # Gets packages from file
  while read -r pkg; do
    packages+=("$pkg")
  done <"packages_flatpak.txt"

  # Loops through packages array
  for pkg in "${packages[@]}"; do
    if ! flatpak list --app --columns=application | grep -Fxq "$pkg"; then
      sudo flatpak install -y --noninteractive flathub "$pkg" || {
        echo "Failed to install $pkg. Please check the package name or your internet connection."
        exit 1
      }
    else
      echo "$pkg is already installed."
    fi
  done
}

update_system
is_arch_based
install_packages_pacman
install_packages_flatpak

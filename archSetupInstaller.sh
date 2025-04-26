#!/bin/bash

is_arch_based() {
  if grep -q '^ID_LIKE=*arch*' /etc/os-release; then
    echo "Arch-based distribution detected."
    return 0
  else
    echo "This script is intended for Arch-based distributions only."
    return 1
  fi
}

is_arch_based

check_packages() {
  local packages=("yay" "waybar")
  local missing=()

  for pkg in "${packages[@]}"; do
    if ! pacman -Qi "$pkg" &>/dev/null; then
      missing+=("$pkg")
    else
      echo "$pkg is already installed."
    fi
  done
}

check_packages

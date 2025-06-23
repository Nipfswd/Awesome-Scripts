#!/bin/bash

# Auto System Updater - Universal Package Manager

echo "🔄 Auto System Updater"

# Detect package manager
if command -v apt >/dev/null 2>&1; then
    PM="apt"
elif command -v dnf >/dev/null 2>&1; then
    PM="dnf"
elif command -v yum >/dev/null 2>&1; then
    PM="yum"
elif command -v pacman >/dev/null 2>&1; then
    PM="pacman"
else
    echo "❌ No supported package manager found."
    exit 1
fi

echo "Detected package manager: $PM"
echo

case "$PM" in
    apt)
        echo "Updating APT packages..."
        sudo apt update && sudo apt upgrade -y
        echo "Cleaning up..."
        sudo apt autoremove -y
        sudo apt autoclean -y
        ;;
    dnf)
        echo "Updating DNF packages..."
        sudo dnf upgrade --refresh -y
        echo "Cleaning up..."
        sudo dnf autoremove -y
        sudo dnf clean all
        ;;
    yum)
        echo "Updating YUM packages..."
        sudo yum update -y
        echo "Cleaning up..."
        sudo yum autoremove -y
        sudo yum clean all
        ;;
    pacman)
        echo "Updating Pacman packages..."
        sudo pacman -Syu --noconfirm
        echo "Cleaning up..."
        sudo pacman -Sc --noconfirm
        ;;
esac

echo
echo "✅ System update complete!"

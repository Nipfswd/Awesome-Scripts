#!/bin/bash

# ==========================
# Auto System Updater
# Author: Noah.J
# ==========================

LOGFILE="/tmp/system_update_$(date +%Y%m%d_%H%M%S).log"
DRY_RUN=false
SEND_MAIL=false
EMAIL_RECIPIENT=""

# ----------- FUNCTIONS ------------

function log() {
    echo "$1"
    echo "$1" >> "$LOGFILE"
}

function check_space() {
    log "Disk usage:"
    df -h /
}

function notify() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "System Updater" "$1"
    fi
}

function send_report() {
    if $SEND_MAIL && [ -n "$EMAIL_RECIPIENT" ]; then
        mail -s "System Update Report" "$EMAIL_RECIPIENT" < "$LOGFILE"
    fi
}

function update_apt() {
    log "🔄 Running APT updates..."
    $DRY_RUN || (sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt autoclean -y)
}

function update_dnf() {
    log "🔄 Running DNF updates..."
    $DRY_RUN || (sudo dnf upgrade --refresh -y && sudo dnf autoremove -y && sudo dnf clean all)
}

function update_yum() {
    log "🔄 Running YUM updates..."
    $DRY_RUN || (sudo yum update -y && sudo yum autoremove -y && sudo yum clean all)
}

function update_pacman() {
    log "🔄 Running Pacman updates..."
    $DRY_RUN || (sudo pacman -Syu --noconfirm && sudo pacman -Sc --noconfirm)
}

function update_flatpak() {
    if command -v flatpak >/dev/null 2>&1; then
        log "🔄 Updating Flatpak apps..."
        $DRY_RUN || sudo flatpak update -y
    fi
}

function update_snap() {
    if command -v snap >/dev/null 2>&1; then
        log "🔄 Updating Snap packages..."
        $DRY_RUN || sudo snap refresh
    fi
}

# ----------- MAIN ------------

log "🧹 Starting system maintenance..."
check_space
log ""

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
    log "❌ No supported package manager found."
    notify "Update failed: No supported package manager"
    exit 1
fi

log "Detected package manager: $PM"
log ""

# Confirm run
read -p "Proceed with full update and cleanup? (y/n): " CONFIRM
if [[ "$CONFIRM" != "y" ]]; then
    log "Aborted by user."
    exit 0
fi

# Run updates
case "$PM" in
    apt) update_apt ;;
    dnf) update_dnf ;;
    yum) update_yum ;;
    pacman) update_pacman ;;
esac

update_flatpak
update_snap

log ""
check_space
log "✅ Update complete!"
notify "System successfully updated."

# Send optional email report
send_report

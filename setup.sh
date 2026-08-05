#!/bin/bash
# POTEMAYOMUSIC Setup Script (local development only)
# On Render, use the Dockerfile + render.yaml instead of this script.

set -e  # Exit immediately on any error

# ─── Color helpers ────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[0;33m'
BLUE='\033[0;34m'; PURPLE='\033[0;35m'; RESET='\033[0m'

info()    { printf "${PURPLE}%s${RESET}\n" "$1"; }
success() { printf "${GREEN}%s${RESET}\n"  "$1"; }
warn()    { printf "${YELLOW}%s${RESET}\n" "$1"; }
error()   { printf "${RED}%s${RESET}\n"    "$1"; }

yesnoprompt() {
    old_stty_cfg=$(stty -g)
    stty raw -echo
    answer=$(head -c 1)
    stty "$old_stty_cfg"
    echo "$answer" | grep -iq "^y"
}

# ─── System update ────────────────────────────────────────────────────────────
update() {
    info "Updating package list..."
    sudo apt-get update -qq
    if apt-get -s upgrade 2>/dev/null | grep -q "^Inst"; then
        warn "Upgrades available. Do you want to upgrade now? (y/n)"
        if yesnoprompt; then
            info "Upgrading packages..."
            sudo apt-get upgrade -y -qq && success "Packages upgraded." || { error "Upgrade failed."; exit 1; }
        fi
    else
        success "System is already up to date."
    fi
}


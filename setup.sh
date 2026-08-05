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

# ─── Install system packages ──────────────────────────────────────────────────
packages() {
    # pip / python3-pip
    if ! command -v pip3 &>/dev/null; then
        info "pip not found — installing python3-pip..."
        sudo apt-get install -y python3-pip -qq && success "pip installed." || { error "pip install failed."; exit 1; }
    fi

    # ffmpeg
    if ! command -v ffmpeg &>/dev/null; then
        info "ffmpeg not found — installing..."
        sudo apt-get install -y ffmpeg -qq && success "ffmpeg installed." || {
            error "ffmpeg install failed. Install it manually before running the bot."
            exit 1
        }
    fi

    # Warn if ffmpeg is version 3 (live streams need v4+)
    ffmpeg_version=$(ffmpeg -version 2>&1 | grep -oP 'version \K[0-9]+' | head -1)
    if [[ "$ffmpeg_version" -lt 4 ]]; then
        warn "You have ffmpeg v${ffmpeg_version}. Live stream playback requires ffmpeg v4+."
    else
        success "ffmpeg v${ffmpeg_version} — OK."
    fi
}


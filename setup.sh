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

# ───  Node.js ─────────────────────────────────────Install─────────────────────
install_node() {
    if command -v npm &>/dev/null; then
        success "Node.js/npm already installed."
        return
    fi
    info "Installing Node.js and npm..."
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - >nodelog.txt 2>&1
    sudo apt-get install -y nodejs >>nodelog.txt 2>&1
    sudo npm install -g npm >>nodelog.txt 2>&1
    success "Node.js installed." || { error "Node.js install failed. See nodelog.txt"; exit 1; }
}

# ─── Install Python dependencies ──────────────────────────────────────────────
installation() {
    info "Upgrading pip and installing Python dependencies..."
    pip3 install --upgrade pip >>pypilog.txt 2>&1
    pip3 install -r requirements.txt >>pypilog.txt 2>&1 && success "Python dependencies installed." || {
        error "Dependency install failed. See pypilog.txt"
        exit 1
    }
}

# ─── Write .env interactively ────────────────────────────────────────────────
write_env() {
    printf "${PURPLE}Enter your bot credentials:\n${RESET}"

    printf "API ID: ";        read -r api_id
    printf "API HASH: ";      read -r api_hash
    printf "BOT TOKEN: ";     read -r bot_token
    printf "OWNER ID: ";      read -r owner_id
    printf "MONGO DB URI: ";  read -r mongo_db
    printf "LOG GROUP ID: ";  read -r logger
    printf "STRING SESSION: ";read -r string_session

    rm -f .env
    cat > .env <<EOF
API_ID=${api_id}
API_HASH=${api_hash}
BOT_TOKEN=${bot_token}
MONGO_DB_URI=${mongo_db}
LOGGER_ID=${logger}
STRING_SESSION=${string_session}
OWNER_ID=${owner_id}
EOF
    success ".env written successfully."
}

# ─── Main ─────────────────────────────────────────────────────────────────────
clear
info "Welcome to POTEMAYOMUSIC Setup Installer"
info "Logs: nodelog.txt (Node.js errors), pypilog.txt (Python errors)"
sleep 1

# Validate sudo access upfront
info "Checking sudo privileges..."
sudo -v || { error "sudo is required. Run as a user with sudo access."; exit 1; }

update
packages
install_node
installation
write_env

echo
success "POTEMAYOMUSIC installation complete!"
info "Start the bot with:  bash start"

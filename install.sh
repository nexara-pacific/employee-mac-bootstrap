#!/usr/bin/env bash
# Stage 0 — Public bootstrap for new Nexara Pacific Technologies employee Macs.
#
# What this does:
#   1. Verify macOS
#   2. Install Xcode Command Line Tools (if missing)
#   3. Install Homebrew (if missing)
#   4. Install gh (GitHub CLI)
#   5. Authenticate to GitHub (device-code flow — opens browser)
#   6. Clone the private employee-mac-setup repo
#   7. Hand off to its ./install (dotbot)
#
# Run by pasting this into Terminal:
#   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/nexara-pacific/employee-mac-bootstrap/main/install.sh)"

set -euo pipefail

PRIVATE_REPO="nexara-pacific/employee-mac-setup"
TARGET_DIR="${HOME}/employee-mac-setup"

log()  { printf "\n\033[1;34m==>\033[0m %s\n" "$*"; }
warn() { printf "\n\033[1;33m!!\033[0m  %s\n" "$*"; }
err()  { printf "\n\033[1;31mxx\033[0m  %s\n" "$*" >&2; }

# --- 1. macOS check ---
[[ "$(uname)" == "Darwin" ]] || { err "macOS only."; exit 1; }

log "Welcome to your Nexara Pacific Technologies Mac setup."
echo "    This will take 15-30 minutes. Plug in your power adapter."

# --- 2. Xcode Command Line Tools ---
if ! xcode-select -p >/dev/null 2>&1; then
  log "Installing Xcode Command Line Tools (a popup will appear — click Install)"
  xcode-select --install || true
  echo "    Waiting for Xcode CLT install to finish..."
  until xcode-select -p >/dev/null 2>&1; do
    sleep 10
  done
fi

# --- 3. Homebrew ---
if ! command -v brew >/dev/null 2>&1; then
  log "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Make brew available in this shell session (Apple Silicon path)
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# --- 4. gh ---
if ! command -v gh >/dev/null 2>&1; then
  log "Installing GitHub CLI (gh)"
  brew install gh
fi

# --- 5. GitHub auth ---
if ! gh auth status >/dev/null 2>&1; then
  log "Sign in to GitHub (browser will open with a one-time code)"
  gh auth login --web --git-protocol https --hostname github.com
else
  log "Already authenticated to GitHub as $(gh api user --jq .login)"
fi

# --- 6. Clone the private repo ---
if [[ -d "${TARGET_DIR}" ]]; then
  warn "${TARGET_DIR} already exists. Pulling latest."
  git -C "${TARGET_DIR}" pull --ff-only
else
  log "Cloning private repo to ${TARGET_DIR}"
  gh repo clone "${PRIVATE_REPO}" "${TARGET_DIR}"
fi

# --- 7. Run Stage 1 (dotbot) ---
log "Handing off to Stage 1 installer (dotbot)"
cd "${TARGET_DIR}"
./install

log "Stage 0 + 1 complete."

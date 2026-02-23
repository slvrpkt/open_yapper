#!/usr/bin/env bash

set -euo pipefail

log() {
  echo "==> $1"
}

warn() {
  echo "WARNING: $1"
}

error() {
  echo "ERROR: $1"
  exit 1
}

if [[ "$(uname -s)" != "Darwin" ]]; then
  error "This script is for macOS only."
fi

log "Starting Flutter + macOS setup..."

if ! xcode-select -p >/dev/null 2>&1; then
  log "Xcode Command Line Tools are missing. Opening installer..."
  xcode-select --install || true
  warn "Finish the Command Line Tools install, then run this script again."
  exit 1
fi

if ! command -v brew >/dev/null 2>&1; then
  log "Homebrew not found. Installing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
else
  error "Homebrew installed, but brew is still not available in PATH."
fi

shell_name="$(basename "${SHELL:-zsh}")"
if [[ "$shell_name" == "zsh" ]]; then
  rc_file="$HOME/.zshrc"
elif [[ "$shell_name" == "bash" ]]; then
  rc_file="$HOME/.bash_profile"
else
  rc_file="$HOME/.profile"
fi

if [[ -x /opt/homebrew/bin/brew ]]; then
  shellenv_line='eval "$(/opt/homebrew/bin/brew shellenv)"'
else
  shellenv_line='eval "$(/usr/local/bin/brew shellenv)"'
fi

if [[ ! -f "$rc_file" ]]; then
  touch "$rc_file"
fi

if ! rg -F "$shellenv_line" "$rc_file" >/dev/null 2>&1; then
  log "Adding Homebrew PATH setup to $rc_file"
  {
    echo ""
    echo "# Added by Open Yapper Flutter setup"
    echo "$shellenv_line"
  } >>"$rc_file"
fi

if ! command -v flutter >/dev/null 2>&1; then
  log "Installing Flutter..."
  brew install --cask flutter
else
  log "Flutter already installed."
fi

log "Enabling Flutter macOS desktop support..."
flutter config --enable-macos-desktop

log "Running Flutter doctor (this may take a minute)..."
flutter doctor -v

echo ""
log "Setup complete."
echo "Next steps:"
echo "  1) Open a new Terminal window"
echo "  2) Clone this repo"
echo "  3) Run: flutter pub get"
echo "  4) Build release: flutter build macos --release"
echo "  5) Install app from: build/macos/Build/Products/Release/open_yapper.app"

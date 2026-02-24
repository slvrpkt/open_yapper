#!/bin/bash
#
# Release preflight checks for macOS artifacts.
# Verifies microphone entitlement, usage string, bundle id, and notarization status.

set -euo pipefail

APP_NAME_DEFAULT="Open Yapper"
APP_PATH_DEFAULT="build/macos/Build/Products/Release/${APP_NAME_DEFAULT}.app"
DMG_PATH_DEFAULT="open_yapper.dmg"
BUNDLE_ID_DEFAULT="com.matin.openYapper"

APP_PATH="$APP_PATH_DEFAULT"
DMG_PATH="$DMG_PATH_DEFAULT"
EXPECTED_BUNDLE_ID="$BUNDLE_ID_DEFAULT"
APP_NAME="$APP_NAME_DEFAULT"
SKIP_STAPLER_CHECK=0

log() {
  echo "==> $1"
}

fail() {
  echo "ERROR: $1" >&2
  exit 1
}

usage() {
  cat <<'EOF'
Usage: ./scripts/release-preflight.sh [options]

Options:
  --app <path>         Path to .app (default: build/macos/Build/Products/Release/Open Yapper.app)
  --dmg <path>         Path to .dmg (default: open_yapper.dmg)
  --bundle-id <id>     Expected CFBundleIdentifier (default: com.matin.openYapper)
  --app-name <name>    App bundle name inside DMG (default: Open Yapper)
  --skip-stapler       Skip stapler/spctl checks
  -h, --help           Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --app)
      APP_PATH="${2:-}"
      shift 2
      ;;
    --dmg)
      DMG_PATH="${2:-}"
      shift 2
      ;;
    --bundle-id)
      EXPECTED_BUNDLE_ID="${2:-}"
      shift 2
      ;;
    --app-name)
      APP_NAME="${2:-}"
      shift 2
      ;;
    --skip-stapler)
      SKIP_STAPLER_CHECK=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      fail "Unknown argument: $1"
      ;;
  esac
done

[[ -d "$APP_PATH" ]] || fail "App not found: $APP_PATH"
[[ -f "$DMG_PATH" ]] || fail "DMG not found: $DMG_PATH"

check_entitlements() {
  local target="$1"
  local ents

  ents="$(codesign -d --entitlements :- "$target" 2>/dev/null || true)"
  [[ -n "$ents" ]] || fail "No entitlements present on: $target"

  if ! printf '%s\n' "$ents" | awk '
    /com.apple.security.device.audio-input/ { found=1; next }
    found && /<true\/>/ { ok=1; exit }
    END { exit ok ? 0 : 1 }
  '; then
    fail "Missing or disabled com.apple.security.device.audio-input on: $target"
  fi
}

check_info_plist() {
  local app_bundle="$1"
  local info_path="$app_bundle/Contents/Info"
  local bundle_id
  local mic_usage

  bundle_id="$(defaults read "$info_path" CFBundleIdentifier 2>/dev/null || true)"
  [[ -n "$bundle_id" ]] || fail "Missing CFBundleIdentifier in: $app_bundle"
  [[ "$bundle_id" == "$EXPECTED_BUNDLE_ID" ]] || fail "Bundle ID mismatch. Expected $EXPECTED_BUNDLE_ID, got $bundle_id"

  mic_usage="$(defaults read "$info_path" NSMicrophoneUsageDescription 2>/dev/null || true)"
  [[ -n "$mic_usage" ]] || fail "Missing NSMicrophoneUsageDescription in: $app_bundle"
}

log "Checking built app: $APP_PATH"
check_entitlements "$APP_PATH"
check_info_plist "$APP_PATH"
codesign --verify --deep --strict --verbose=2 "$APP_PATH" >/dev/null

log "Mounting DMG: $DMG_PATH"
ATTACH_OUTPUT="$(hdiutil attach "$DMG_PATH" -nobrowse -readonly)"
MOUNT_POINT="$(printf '%s\n' "$ATTACH_OUTPUT" | awk -F '\t' '/\/Volumes\// { mp=$3 } END { print mp }')"
[[ -n "$MOUNT_POINT" ]] || fail "Could not determine DMG mount point."

cleanup() {
  if [[ -n "${MOUNT_POINT:-}" ]]; then
    hdiutil detach "$MOUNT_POINT" >/dev/null 2>&1 || true
  fi
}
trap cleanup EXIT

DMG_APP_PATH="$MOUNT_POINT/$APP_NAME.app"
[[ -d "$DMG_APP_PATH" ]] || fail "App not found in DMG at: $DMG_APP_PATH"

log "Checking app inside DMG: $DMG_APP_PATH"
check_entitlements "$DMG_APP_PATH"
check_info_plist "$DMG_APP_PATH"

if [[ "$SKIP_STAPLER_CHECK" -eq 0 ]]; then
  log "Validating notarization staple..."
  xcrun stapler validate "$DMG_PATH" >/dev/null
  spctl -a -vv -t open --context context:primary-signature "$DMG_PATH" >/dev/null
fi

log "Release preflight passed."
echo "Microphone entitlement and macOS distribution checks are OK."

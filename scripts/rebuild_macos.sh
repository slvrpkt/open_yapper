#!/bin/bash
# Force a complete clean rebuild of the macOS app.
# Use this when native Swift changes (e.g. overlay pill design) don't appear.

set -e
cd "$(dirname "$0")/.."

echo "Cleaning Flutter..."
flutter clean

echo "Clearing Xcode DerivedData for Runner..."
rm -rf ~/Library/Developer/Xcode/DerivedData/Runner-* 2>/dev/null || true
rm -rf ~/Library/Developer/Xcode/DerivedData/OpenYappertest-* 2>/dev/null || true

echo "Getting dependencies..."
flutter pub get

echo "Building macOS app (this compiles Swift from scratch)..."
flutter build macos

echo ""
echo "Done! Run the app with:"
echo "  open build/macos/Build/Products/Release/open_yapper.app"
echo ""
echo "Or use: flutter run -d macos"
echo ""

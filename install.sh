#!/usr/bin/env bash
set -euo pipefail

APP_NAME="Ajan Kalkanı"
APP_BUNDLE="/Applications/${APP_NAME}.app"
BUILD_DIR="./build"

echo "🛡️  ${APP_NAME} derleniyor (Native Swift 6 / ARM64)..."
mkdir -p "${BUILD_DIR}"

swiftc -O -parse-as-library \
  ./Sources/AjanKalkaniApp.swift \
  -o "${BUILD_DIR}/AjanKalkani" \
  -framework SwiftUI \
  -framework AppKit \
  -framework IOKit \
  -framework ServiceManagement

echo "📦 Uygulama paketi oluşturuluyor: ${APP_BUNDLE}"
killall -9 AjanKalkani 2>/dev/null || true
rm -f "$HOME/Library/LaunchAgents/com.ugurhoca.ajankalkani.plist" "$HOME/Library/Preferences/com.ugurhoca.ajankalkani.plist"
mkdir -p "${APP_BUNDLE}/Contents/MacOS" "${APP_BUNDLE}/Contents/Resources"
cp "${BUILD_DIR}/AjanKalkani" "${APP_BUNDLE}/Contents/MacOS/AjanKalkani"
cp "./Resources/Info.plist" "${APP_BUNDLE}/Contents/Info.plist"
cp "./Resources/AppIcon.icns" "${APP_BUNDLE}/Contents/Resources/AppIcon.icns"
rm -rf "${BUILD_DIR}"

codesign --force --deep --sign - "${APP_BUNDLE}"

echo "✅ Kurulum tamamlandı! Uygulama başlatılıyor..."
open -a "${APP_BUNDLE}"

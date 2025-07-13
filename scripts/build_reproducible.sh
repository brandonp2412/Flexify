#!/bin/bash

# Reproducible Flutter build script
# This script ensures consistent build outputs for F-Droid reproducibility

set -e

echo "Setting up reproducible build environment..."

# Set deterministic environment variables
export SOURCE_DATE_EPOCH=1
export TZ=UTC
export LC_ALL=C

# Disable Flutter analytics and crash reporting
export FLUTTER_SUPPRESS_ANALYTICS=true
export PUB_CACHE="${PUB_CACHE:-$(pwd)/.pub-cache}"

# Clean previous builds
echo "Cleaning previous builds..."
flutter clean
rm -rf build/
rm -rf .dart_tool/

# Get dependencies
echo "Getting Flutter dependencies..."
flutter pub get

# Build with reproducible flags
echo "Building APK with reproducible settings..."
flutter build apk \
    --release \
    --split-per-abi \
    --no-tree-shake-icons \
    --dart-define=FLUTTER_WEB_AUTO_DETECT=false \
    --dart-define=FLUTTER_WEB_CANVASKIT_URL=https://unpkg.com/canvaskit-wasm@0.39.1/bin/ \
    "$@"

echo "Build completed successfully!"

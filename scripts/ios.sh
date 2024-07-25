#!/bin/sh

set -e

source "$HOME/.zprofile"
cd "$HOME/flexify"
git pull
security unlock-keychain -p ''
flutter build ipa
fastlane deliver --ipa build/ios/ipa/flexify.ipa

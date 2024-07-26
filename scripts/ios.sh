#!/bin/sh

set -e

cd "$HOME/flexify"
git pull
security unlock-keychain -p ''
flutter build ipa
fastlane deliver --ipa build/ios/ipa/flexify.ipa

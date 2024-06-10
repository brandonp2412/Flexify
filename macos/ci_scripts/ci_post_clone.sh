#!/bin/sh

set -e

cd $CI_PRIMARY_REPOSITORY_PATH
git clone https://github.com/flutter/flutter.git --depth 1 -b stable $HOME/flutter
export PATH="$PATH:$HOME/flutter/bin"

flutter precache --macos
flutter pub get
HOMEBREW_NO_AUTO_UPDATE=1
brew install cocoapods
cd macos && pod install
flutter build macos

exit 0

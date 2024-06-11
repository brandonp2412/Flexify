#!/bin/sh

set -e

cd $CI_PRIMARY_REPOSITORY_PATH
git clone https://github.com/flutter/flutter.git --depth 1 -b 3.22.2 $HOME/flutter
export PATH="$PATH:$HOME/flutter/bin"

flutter precache --macos
flutter pub get
flutter build macos --debug
HOMEBREW_NO_AUTO_UPDATE=1
brew install cocoapods
cd macos && pod install

exit 0

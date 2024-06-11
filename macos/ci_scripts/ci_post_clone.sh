#!/bin/sh

set -e

cd $CI_PRIMARY_REPOSITORY_PATH
<<<<<<< HEAD
export PATH="$PATH:$HOME/flutter/bin"
=======
export PATH="$PATH:$(pwd)/flutter/bin"
>>>>>>> 83c444416cab69160e8e9703d9bdc7ceccb715b5

flutter precache --macos
flutter pub get
HOMEBREW_NO_AUTO_UPDATE=1
brew install cocoapods
flutter build macos --debug
cd macos && pod install

exit 0

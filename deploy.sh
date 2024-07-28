#!/bin/bash

set -ex

export PUB_SUMMARY_ONLY=true

./scripts/tag-release.sh
./scripts/github.sh

if [[ $* == *-w* ]]; then
  echo "Skipping Windows store..."
else
  ./scripts/msstore.sh "$HOME/windows/flexify.msix" || true
fi

if [[ $* == *-p* ]]; then
  echo "Skipping Google play..."
else
  bundle exec fastlane supply --aab \
    build/app/outputs/bundle/release/app-release.aab || true
fi

if [[ $* == *-m* ]]; then
  echo "Skipping MacOS..."
else
  set +x
  # shellcheck disable=SC2029
  ssh macbook "
    set -e
    source .zprofile 
    cd flexify
    git pull 
    security unlock-keychain -p $(pass macbook)
    ./scripts/macos.sh || true
    ./scripts/ios.sh
  "
fi

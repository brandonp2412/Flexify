#!/bin/bash

set -ex

git diff-files --quiet || exit 1

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
  ip=$(arp | grep "$MACBOOK_MAC" | cut -d ' ' -f 1)
  # shellcheck disable=SC2029
  ssh "$ip" "
    security unlock-keychain -p '$(pass macbook)'
    cd flexify
    git pull
    ./scripts/macos.sh
  "
fi

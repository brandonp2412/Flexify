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
  rsync -a --exclude-from=.gitignore ./* .git .gitignore \
    --exclude=flutter macos:~/flexify
  # shellcheck disable=SC2029
  ssh macos "
    security unlock-keychain -p '$(pass macbook)'
    cd flexify
    ./scripts/macos.sh
  "
fi

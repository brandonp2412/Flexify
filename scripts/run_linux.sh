#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p build/linux/x64/debug
if [ ! -f build/linux/x64/debug/CMakeCache.txt ]; then
  cmake -S linux -B build/linux/x64/debug \
    -DFLUTTER_TARGET_PLATFORM=linux-x64 \
    -DCMAKE_BUILD_TYPE=Debug > /dev/null
fi
exec flutter run -d linux "$@"

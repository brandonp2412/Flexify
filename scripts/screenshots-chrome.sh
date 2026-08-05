#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/screenshot-names.sh"

device_type=""
only=""
show=0

for arg in "$@"; do
    case "$arg" in
    --show | --headed) show=1 ;;
    *)
        if [ -z "$device_type" ]; then
            device_type="$arg"
        elif [ -z "$only" ]; then
            only="$arg"
        fi
        ;;
    esac
done
device_type="${device_type:-desktop}"

echo "Running screenshot tests with Chrome..."

# Set environment variables for device type and platform
export FLEXIFY_DEVICE_TYPE="$device_type"
export FLEXIFY_WEB="true"

dart_define=()
if [ -n "$only" ]; then
    only="$(screenshot_name "$only")"
    dart_define=(--dart-define=SCREENSHOT_ONLY="$only")
    echo "Capturing only: $only"
fi

headless_flag=(--headless)
[ "$show" -eq 1 ] && headless_flag=()

chromedriver_pid=""
cleanup() {
    [ -n "$chromedriver_pid" ] || return 0
    kill -TERM "$chromedriver_pid" >/dev/null 2>&1 || true
    wait "$chromedriver_pid" 2>/dev/null || true
}
trap cleanup EXIT

if ! curl -s -o /dev/null http://localhost:4444/status; then
    echo "Starting chromedriver on port 4444..."
    chromedriver --port=4444 >/tmp/flexify-chromedriver.log 2>&1 &
    chromedriver_pid=$!

    for _ in $(seq 1 20); do
        curl -s -o /dev/null http://localhost:4444/status && break
        sleep 0.5
    done

    if ! curl -s -o /dev/null http://localhost:4444/status; then
        echo "ERROR: chromedriver did not become ready on port 4444"
        exit 1
    fi
fi

# Run Flutter drive command targeting Chrome
flutter drive --profile --driver=test_driver/integration_test.dart \
    --target=integration_test/screenshot_test.dart \
    "${dart_define[@]}" \
    -d chrome "${headless_flag[@]}"

echo "Screenshot tests completed successfully!"

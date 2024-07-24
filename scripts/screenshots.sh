#!/bin/bash

set -e

device_type="${1:-phoneScreenshots}"

case "$(uname -s)" in 
  Linux*)
    echo "Launching $device_type..."
    $TERMINAL -t Hide emulator -avd "$device_type" -feature -Vulkan \
      -no-boot-anim -noaudio -no-window &> /dev/null &

    while true; do  
      for device in $(adb devices | awk 'NR>1{print $1}' | grep emulator); do
        name=$(
          adb -s "$device" emu avd name 2> /dev/null | head -n 1 | tr -d '\r'
        ) 
        [ "$name" = "$device_type" ] && break
      done

      boot_completed=$(
        adb -s "$device" shell getprop sys.boot_completed 2> /dev/null \
          | tr -d '\r'
      )
      adb -s "$device" get-state 2> /dev/null | grep -q device && \
        [ "$name" = "$device_type" ] && [ "$boot_completed" = "1" ] \
        && break

      sleep 1
    done
  ;;
esac

export FLEXIFY_DEVICE_TYPE="$device_type"

flutter drive --driver=test_driver/integration_test.dart \
  --target=integration_test/screenshot_test.dart \
  --dart-define=FLEXIFY_DEVICE_TYPE="$device_type" -d "${device:-$device_type}"
code=$?

case "$(uname -s)" in 
  Linux*)
    adb -s "$device" reboot -p
    exit $code
  ;;
esac

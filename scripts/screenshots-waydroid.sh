#!/bin/bash

set -uo pipefail

# Tunables (override via environment).
MAX_ATTEMPTS="${MAX_ATTEMPTS:-3}"        # retries per resolution before giving up
DRIVE_TIMEOUT="${DRIVE_TIMEOUT:-600}"    # seconds before a hung install/drive is killed
BOOT_TIMEOUT="${BOOT_TIMEOUT:-90}"       # seconds to wait for the session to reach RUNNING

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BASE_PROP="/var/lib/waydroid/waydroid_base.prop"

device=""
ip=""
show=0

for arg in "$@"; do
    case "$arg" in
        --show|--headed) show=1 ;;
    esac
done

log() {
    printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

# Prefix every line of piped output with a timestamp. Carriage returns (used by
# Flutter/Gradle progress spinners) are converted to newlines so long-running
# steps still emit timestamped lines and a hang is obvious.
add_timestamps() {
    stdbuf -oL tr '\r' '\n' | while IFS= read -r line; do
        printf '[%s] %s\n' "$(date '+%H:%M:%S')" "$line"
    done
}

run_with_timeout() {
    local secs="$1"
    shift
    timeout --foreground -k 20 "$secs" "$@"
}

# Kill any adb install left hung against the Waydroid device. A stuck install
# holds the package-installer transaction and blocks every subsequent adb call.
cleanup_hung_adb() {
    [ -n "$device" ] || return 0
    pkill -TERM -f "adb -s ${device} install" 2>/dev/null || true
    sleep 2
    pkill -KILL -f "adb -s ${device} install" 2>/dev/null || true
    adb disconnect "$device" >/dev/null 2>&1 || true
}

# The Waydroid PackageManager intermittently deadlocks after boot; when it does,
# `adb install` (and thus `flutter drive`) hangs forever. `pm path android`
# returns instantly when healthy and hangs when wedged, so use it as a probe.
pm_ready() {
    local dev="$1" i
    for i in $(seq 1 8); do
        if timeout 20 adb -s "$dev" shell pm path android >/dev/null 2>&1; then
            return 0
        fi
        log "  package manager not responding yet (probe $i/8)..."
        sleep 5
    done
    return 1
}

# Restart Waydroid at the requested resolution and reconnect adb. Sets the
# globals `ip` and `device`. Returns non-zero if the device never comes up.
bring_up_waydroid() {
    local w="$1" h="$2" _

    log "Setting Waydroid resolution to ${w}x${h}"
    # qemu.hw.mainkeys=1 tells Android the device has hardware navigation keys, so
    # SystemUI never draws the on-screen navigation bar. Without it the opaque nav
    # bar is captured as a black strip at the bottom of every screenshot, since
    # integration_test PixelCopies the FlutterView rect straight from the window.
    sudo sed -i '/^persist\.waydroid\.width=/d;/^persist\.waydroid\.height=/d;/^qemu\.hw\.mainkeys=/d' "$BASE_PROP"
    printf 'persist.waydroid.width=%s\npersist.waydroid.height=%s\nqemu.hw.mainkeys=1\n' "$w" "$h" | sudo tee -a "$BASE_PROP" >/dev/null

    log "Stopping Waydroid session/container for a clean boot..."
    cleanup_hung_adb
    sudo waydroid container stop >/dev/null 2>&1 || true
    waydroid session stop >/dev/null 2>&1 || true
    for _ in $(seq 1 30); do
        timeout 10 waydroid status 2>/dev/null | grep -q "Session:.*STOPPED" && break
        sleep 1
    done

    log "Starting Waydroid session..."
    waydroid session start >/dev/null 2>&1 &
    for _ in $(seq 1 "$BOOT_TIMEOUT"); do
        timeout 10 waydroid status 2>/dev/null | grep -q "Session:.*RUNNING" && break
        sleep 1
    done
    if ! timeout 10 waydroid status 2>/dev/null | grep -q "Session:.*RUNNING"; then
        log "ERROR: Waydroid session did not reach RUNNING within ${BOOT_TIMEOUT}s"
        return 1
    fi

    if [ "$show" -eq 1 ]; then
        log "Showing Waydroid full UI..."
        waydroid show-full-ui >/dev/null 2>&1 &
    fi

    log "Waiting for Waydroid IP address..."
    ip=""
    for _ in $(seq 1 30); do
        ip="$(timeout 10 waydroid status 2>/dev/null | awk -F'\t' '/IP address/ {print $2}')"
        [ -n "$ip" ] && [ "$ip" != "UNKNOWN" ] && break
        sleep 1
    done
    if [ -z "$ip" ] || [ "$ip" = "UNKNOWN" ]; then
        log "ERROR: could not determine Waydroid IP address"
        return 1
    fi
    log "Waydroid IP: $ip"

    log "Ensuring adbd is running inside Waydroid..."
    sudo waydroid shell start adbd >/dev/null 2>&1 || true

    device="$ip:5555"
    log "Connecting adb to $device..."
    adb disconnect "$device" >/dev/null 2>&1 || true
    for _ in $(seq 1 30); do
        timeout 10 adb connect "$device" 2>/dev/null | grep -q "connected" && break
        sleep 2
    done

    log "Waiting for device to be ready..."
    if ! timeout 60 adb -s "$device" wait-for-device; then
        log "ERROR: device $device did not become ready"
        return 1
    fi

    # persist.waydroid.width/height (written to waydroid_base.prop above) are not
    # honoured for the display size in this multi-window/headless Waydroid setup,
    # so every device_type otherwise boots at the default (phone) resolution.
    # Force the size through WindowManager after boot; the app is launched by
    # flutter drive afterwards, so it starts at the requested resolution.
    log "Forcing display resolution to ${w}x${h}..."
    timeout 20 adb -s "$device" shell wm size reset >/dev/null 2>&1 || true
    timeout 20 adb -s "$device" shell wm size "${w}x${h}" 2>&1 | add_timestamps || true
    sleep 2

    log "Verifying screen size..."
    timeout 20 adb -s "$device" shell wm size 2>&1 | add_timestamps || true
    return 0
}

# Run one device_type end to end, restarting Waydroid and retrying on any hang.
run_device_type() {
    local device_type="$1" w="$2" h="$3" attempt rc

    for attempt in $(seq 1 "$MAX_ATTEMPTS"); do
        log "=== [$device_type] attempt ${attempt}/${MAX_ATTEMPTS} (resolution ${w}x${h}) ==="

        if ! bring_up_waydroid "$w" "$h"; then
            log "[$device_type] Waydroid bring-up failed; will restart and retry."
            cleanup_hung_adb
            continue
        fi

        log "[$device_type] Checking package manager health before install..."
        if ! pm_ready "$device"; then
            log "[$device_type] Package manager is WEDGED (install would hang forever); restarting Waydroid and retrying."
            cleanup_hung_adb
            continue
        fi

        log "[$device_type] Running screenshot tests on $device (timeout ${DRIVE_TIMEOUT}s)..."
        run_with_timeout "$DRIVE_TIMEOUT" "$SCRIPT_DIR/screenshots-android.sh" "$device" "$device_type" 2>&1 | add_timestamps
        rc=${PIPESTATUS[0]}

        if [ "$rc" -eq 0 ]; then
            log "[$device_type] Screenshots completed successfully."
            return 0
        elif [ "$rc" -eq 124 ]; then
            log "[$device_type] TIMED OUT after ${DRIVE_TIMEOUT}s (hung install/drive). Recovering and retrying."
        else
            log "[$device_type] Screenshot run failed (exit $rc). Recovering and retrying."
        fi
        cleanup_hung_adb
    done

    log "[$device_type] ERROR: all ${MAX_ATTEMPTS} attempts failed."
    return 1
}

main() {
    local device_type width height
    for device_type in phoneScreenshots sevenInchScreenshots tenInchScreenshots; do
        case "$device_type" in
            phoneScreenshots)     width=1080; height=2424 ;;
            sevenInchScreenshots) width=1920; height=1080 ;;
            tenInchScreenshots)   width=2560; height=1600 ;;
        esac

        if ! run_device_type "$device_type" "$width" "$height"; then
            log "Aborting: could not generate $device_type screenshots."
            exit 1
        fi
    done

    log "=== Running desktop screenshots with Chrome ==="
    local chrome_args=(desktop)
    [ "$show" -eq 1 ] && chrome_args+=(--show)
    "$SCRIPT_DIR/screenshots-chrome.sh" "${chrome_args[@]}" 2>&1 | add_timestamps
    if [ "${PIPESTATUS[0]}" -ne 0 ]; then
        log "ERROR: Chrome screenshots failed."
        exit 1
    fi

    log "All screenshots generated successfully!"
}

main "$@"

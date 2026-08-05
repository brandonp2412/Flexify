#!/bin/bash
# Maps a screenshot number (as used in the fastlane image filenames, e.g.
# "6" for phoneScreenshots/6_en-US.png) to its integration test name (e.g.
# "Settings"). Passed through unchanged if it's already a test name.
screenshot_name() {
    case "$1" in
        1) echo "PlanPage" ;;
        2) echo "GraphPage" ;;
        3) echo "SettingsPage" ;;
        4) echo "StartPlanPage" ;;
        5) echo "ViewGraphPage" ;;
        6) echo "GraphHistory" ;;
        7) echo "EditPlanPage" ;;
        8) echo "TimerPage" ;;
        *) echo "$1" ;;
    esac
}

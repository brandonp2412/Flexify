#!/bin/bash

set -ex  # Exit on any error

echo "🚀 Starting Flexify local build and version process..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_step() {
    echo -e "${BLUE}=== $1 ===${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if yq is installed and is the correct version (mikefarah's Go version)
if ! command -v yq &> /dev/null; then
    print_step "Installing yq (Go version by mikefarah)"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install yq
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
        sudo chmod +x /usr/local/bin/yq
    else
        print_error "Please install yq manually: https://github.com/mikefarah/yq#install"
        exit 1
    fi
elif ! yq --version 2>/dev/null | grep -q "mikefarah"; then
    print_error "Wrong version of yq detected. This script requires mikefarah's Go version of yq."
    echo "You appear to have the Python version installed."
    echo ""
    echo "Please install the correct version:"
    echo "  Linux: wget -qO /tmp/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 && sudo mv /tmp/yq /usr/local/bin/yq && sudo chmod +x /usr/local/bin/yq"
    echo "  macOS: brew install yq"
    echo ""
    echo "Or rename/remove the existing yq command and run this script again."
    exit 1
fi

# Calculate new version
print_step "Calculating new version"
current_version=$(yq e '.version' pubspec.yaml)
IFS='+.' read -r major minor patch build_number <<< "$current_version"

new_patch=$((patch + 1))
new_build_number=$((build_number + 1))
changelog_number=$((new_build_number * 10 + 3))
new_flutter_version="$major.$minor.$new_patch+$new_build_number"
new_version="$major.$minor.$new_patch"

current_msix_version=$(yq e '.msix_config.msix_version' pubspec.yaml)
IFS='.' read -r msix_major msix_minor msix_patch msix_zero <<< "$current_msix_version"
new_msix_patch=$((msix_patch + 1))
new_msix_version="$msix_major.$msix_minor.$new_msix_patch.$msix_zero"

echo "Current version: $current_version"
echo "New version: $new_flutter_version"
echo "MSIX version: $new_msix_version"
echo "Changelog number: $changelog_number"

# Generate changelog
print_step "Generating changelog"
changelog_file="fastlane/metadata/android/en-US/changelogs/$changelog_number.txt"

# Use existing changelog if it exists
if [ -f "$changelog_file" ]; then
    print_warning "Using existing changelog file: $changelog_file"
    cat "$changelog_file"
    changelog=$(cat "$changelog_file")
    mkdir -p fastlane/metadata/en-AU
    echo "$changelog" > fastlane/metadata/en-AU/release_notes.txt
else
    # Generate new changelog
    mkdir -p "$(dirname "$changelog_file")"
    
    last_tag=$(git describe --tags --abbrev=0 2>/dev/null || echo "")
    if [ -z "$last_tag" ]; then
        echo "• Initial release" > "$changelog_file"
        print_success "Generated initial release changelog"
        cat "$changelog_file"
        changelog=$(cat "$changelog_file")
        mkdir -p fastlane/metadata/en-AU
        echo "$changelog" > fastlane/metadata/en-AU/release_notes.txt
    else
        # Generate changelog from git commits
        print_step "Generating changelog from git commits since $last_tag"
        git --no-pager log --pretty=format:'%s' "$last_tag"..HEAD | \
            sort -u | \
            grep -v "^Merge " | \
            grep -v "^Release " | \
            grep -v "^Bump " | \
            grep -v "^Update " | \
            grep -v "^[0-9]\+\.[0-9]\+\.[0-9]\+" | \
            head -10 | \
            sed 's/^/• /' > "$changelog_file"
        
        changelog=$(cat "$changelog_file")
        mkdir -p fastlane/metadata/en-AU
        echo "$changelog" > fastlane/metadata/en-AU/release_notes.txt
        
        print_success "Generated changelog:"
        cat "$changelog_file"
    fi
fi

# Setup Flutter
print_step "Setting up Flutter from submodule"
if [ ! -d "flutter" ]; then
    print_warning "Flutter submodule not found, initializing..."
    git submodule update --init --recursive flutter
else
    git submodule update --recursive flutter
fi

export PATH="$PWD/flutter/bin:$PATH"
chmod +x flutter/bin/* # Ensure executables are runnable

# Run tests and analysis
print_step "Running tests and analysis"
flutter test
print_success "Tests passed"

dart analyze lib
print_success "Analysis passed"

dart format --set-exit-if-changed lib
print_success "Code formatting verified"

# Update versions in pubspec.yaml
print_step "Updating versions in pubspec.yaml"
yq e ".version |= \"$new_flutter_version\"" -i pubspec.yaml
yq e ".msix_config.msix_version |= \"$new_msix_version\"" -i pubspec.yaml
print_success "Updated pubspec.yaml versions"

# Copy changelogs with timestamps
print_step "Copying changelogs with timestamps"
mkdir -p assets/changelogs

for file in fastlane/metadata/android/en-US/changelogs/*.txt; do
    if [ -f "$file" ]; then
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS
            timestamp=$(stat -f "%B" "$file")
        else
            # Linux
            timestamp=$(stat --format="%W" "$file")
        fi
        target_file="assets/changelogs/$timestamp.txt"
        cp "$file" "$target_file"
    fi
done

# Check if Android emulator is available for screenshots
print_step "Checking for Android emulator"
echo "Checking Flutter availability..."
if command -v flutter &> /dev/null; then
    echo "Flutter found, checking Android setup..."
    
    # Check if Android SDK is available without hanging on licenses
    if flutter doctor | grep -q "Android toolchain" && ! flutter doctor | grep -q "\[!\].*Android toolchain"; then
        echo "Android toolchain appears to be configured"
        android_available=true
    else
        echo "Android toolchain not properly configured"
        android_available=false
    fi
else
    echo "Flutter not found"
    android_available=false
fi

generate_screenshots() {
    local avd_name=$1

    print_step "Generating screenshots for AVD '$avd_name'"
    
    if ! command -v emulator &> /dev/null || ! emulator -list-avds | grep -q "^$avd_name$"; then
        print_warning "AVD '$avd_name' not found"
        echo "Available AVDs:"
        emulator -list-avds 2>/dev/null || echo "None found"
        return 1
    fi
    
    print_step "Starting emulator '$avd_name'"
    emulator -avd "$avd_name" -no-window -gpu swiftshader_indirect -noaudio -no-boot-anim -camera-back none &
    emulator_pid=$!
    
    # Wait for emulator to appear and get its ID
    echo "Waiting for emulator to boot..."
    timeout=300
    elapsed=0
    emulator_id=""
    
    while [ $elapsed -lt $timeout ]; do
        # Get any emulator that's now running (should be ours since we killed others)
        emulator_id=$(adb devices | grep "emulator-" | grep "device$" | awk '{print $1}' | head -1)
        
        if [ -n "$emulator_id" ]; then
            print_success "Emulator '$avd_name' booted with ID: $emulator_id"
            break
        fi
        
        # Check if process died
        if ! kill -0 "$emulator_pid" 2>/dev/null; then
            print_error "Emulator process died during startup"
            exit 1
        fi
        
        sleep 5
        elapsed=$((elapsed + 5))
        echo "Waiting... ($elapsed/${timeout}s)"
    done
    
    if [ -z "$emulator_id" ]; then
        print_error "Emulator '$avd_name' failed to boot within timeout"
        kill $emulator_pid 2>/dev/null || true
        exit 1
    fi
    
    # Wait for system to settle
    echo "Waiting for system to settle..."
    sleep 15
    
    # Verify emulator is still available
    if ! adb devices | grep -q "$emulator_id.*device"; then
        print_error "Emulator $emulator_id disappeared"
        kill $emulator_pid 2>/dev/null || true
        exit 1
    fi
    
    print_step "Running screenshot tests on $emulator_id for device type '$avd_name'"
    export FLEXIFY_DEVICE_TYPE="$avd_name"
    
    if flutter drive --profile --driver=test_driver/integration_test.dart \
        --dart-define=FLEXIFY_DEVICE_TYPE=$avd_name \
        --target=integration_test/screenshot_test.dart -d "$emulator_id"; then
        print_success "Screenshots generated successfully for '$avd_name'"
    else
        print_error "Screenshot generation failed for '$avd_name'"
        adb -s "$emulator_id" emu kill 2>/dev/null || kill $emulator_pid 2>/dev/null || true
        exit 1
    fi
    
    print_step "Stopping emulator '$avd_name'"
    adb -s "$emulator_id" emu kill 2>/dev/null || kill $emulator_pid 2>/dev/null || true
    
    # Wait for shutdown
    sleep 5
    print_success "Emulator '$avd_name' stopped"
}

if [[ "$*" == *"-n"* ]]; then
    print_warning "Skipping screenshots"
elif [ "$android_available" = true ]; then
    generate_screenshots phoneScreenshots
    generate_screenshots sevenInchScreenshots
    generate_screenshots tenInchScreenshots
else
    print_warning "Android SDK not properly configured. Skipping screenshot generation."
    echo "Make sure Android SDK and emulator tools are in your PATH"
fi

# Commit changes and create tag
print_step "Committing version bump and creating tag"

# Check if there are changes to commit
if ! git diff --quiet HEAD -- pubspec.yaml fastlane/metadata pubspec.lock assets; then
    git add pubspec.yaml fastlane/metadata pubspec.lock assets
    git commit -m "Release $new_version"
    print_success "Committed version bump"
    
    # Create tag
    git tag "$new_version"
    print_success "Created tag: $new_version"
    
    echo ""
    print_step "Next steps:"
    echo "1. Push changes: git push origin main"
    echo "2. Push tag: git push origin $new_version"
    echo "3. The GitHub Action will handle deployment automatically"
    echo ""
    print_success "Local build process completed successfully!"
    echo "Version: $new_version"
    echo "Tag: $new_version"
else
    print_warning "No changes detected in tracked files"
fi

# Optional: Build locally for testing
print_step "Building locally"

# Check what platforms are available
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Building for macOS..."
    flutter build macos
    print_success "macOS build completed"
fi

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Checking Linux dependencies..."
    missing_deps=()
    
    if ! command -v clang &> /dev/null; then missing_deps+=("clang"); fi
    if ! command -v cmake &> /dev/null; then missing_deps+=("cmake"); fi
    if ! command -v ninja &> /dev/null; then missing_deps+=("ninja-build"); fi
    if ! pkg-config --exists gtk+-3.0 &> /dev/null; then missing_deps+=("libgtk-3-dev"); fi
    if ! pkg-config --exists liblzma &> /dev/null; then missing_deps+=("liblzma-dev"); fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        print_error "Missing Linux dependencies: ${missing_deps[*]}"
        echo "Please install them using your package manager, e.g.:"
        echo "  Ubuntu/Debian: sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev"
        echo "  Fedora: sudo dnf install clang cmake ninja-build pkgconfig gtk3-devel xz-devel"
        echo "  Arch: sudo pacman -S clang cmake ninja pkgconfig gtk3 xz"
        exit 1
    else
        echo "Building for Linux..."
        flutter build linux
        print_success "Linux build completed"
    fi
fi

if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    echo "Building for Windows..."
    flutter build windows
    print_success "Windows build completed"
fi

# Web build (works on all platforms)
echo "Building for Web..."
flutter config --enable-web
flutter build web --release
print_success "Web build completed"

echo ""
print_success "All done! 🎉"
git pull origin main
git push
git push "$new_version"

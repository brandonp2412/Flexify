#!/bin/bash

# Source and target directories
SRC_DIR="fastlane/metadata/android/en-US/changelogs"
DEST_DIR="assets/changelogs"

# Create destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

# Process each text file in source directory
for file in "$SRC_DIR"/*.txt; do
    # Get creation time (birth time) in Unix timestamp format
    timestamp=$(stat --format="%W" "$file")
    
    # If birth time isn't available, use modification time
    if [ "$timestamp" -eq 0 ]; then
        timestamp=$(stat --format="%Y" "$file")
    fi
    
    # Copy file with timestamp filename
    cp "$file" "$DEST_DIR/$timestamp.txt"
    
    echo "Copied $(basename "$file") to $timestamp.txt"
done

echo "All changelogs copied with timestamp filenames to $DEST_DIR"
#!/bin/bash

# Script: Medoshare-Server Installer
# Author: Hamdy_Ahmed
# Description: Install Medoshare-Server on Enigma2 devices
# Version: 1.1
# Required: MagicPanelpro v6.5 or compatible

set -e  # Exit immediately if any command fails

# Colors for better output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
DOWNLOAD_URL="https://raw.githubusercontent.com/Ham-ahmed/medo/refs/heads/main/Medoshare-Server1.tar.gz"
TEMP_DIR="/tmp"
INSTALL_DIR="/"
ARCHIVE_NAME="Medoshare-Server1.tar.gz"
FULL_PATH="$TEMP_DIR/$ARCHIVE_NAME"

# Function to print status messages
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   print_error "This script must be run as root"
   exit 1
fi

# Clean up function
cleanup() {
    if [[ -f "$FULL_PATH" ]]; then
        rm -f "$FULL_PATH"
        print_status "Temporary files cleaned up"
    fi
}

# Trap signals for cleanup
trap cleanup EXIT INT TERM

print_status "Starting Medoshare-Server installation..."
print_status "Working directory: $TEMP_DIR"

# Change to temp directory
cd "$TEMP_DIR" || {
    print_error "Cannot access $TEMP_DIR"
    exit 1
}

# Download the archive
print_status "Downloading Medoshare-Server from GitHub..."
if wget --no-check-certificate -q --show-progress -O "$ARCHIVE_NAME" "$DOWNLOAD_URL"; then
    print_status "Download completed successfully"
else
    print_error "Download failed. Please check your internet connection"
    exit 1
fi

# Verify the downloaded file
if [[ ! -f "$ARCHIVE_NAME" ]]; then
    print_error "Downloaded file not found"
    exit 1
fi

FILE_SIZE=$(stat -c%s "$ARCHIVE_NAME" 2>/dev/null || stat -f%z "$ARCHIVE_NAME" 2>/dev/null)
if [[ $FILE_SIZE -lt 1000 ]]; then
    print_error "Downloaded file is too small or corrupted"
    exit 1
fi

print_status "File size: $FILE_SIZE bytes"

# Extract the archive
print_status "Extracting files to $INSTALL_DIR..."
if tar -xzf "$ARCHIVE_NAME" -C "$INSTALL_DIR"; then
    print_status "Extraction completed successfully"
else
    print_error "Failed to extract archive. File may be corrupted"
    exit 1
fi

# Clean up downloaded file
rm -f "$ARCHIVE_NAME"

# Display success message
echo ""
echo "**************************************************"
echo "#           INSTALLED SUCCESSFULLY              #"
echo "*           MagicPanelpro v6.5                  *"
echo "*     Enigma2 restart is required               *"
echo "**************************************************"
echo "        UPLOADED BY  >>>>   HAMDY_AHMED         "
echo ""

# Wait for user to see the message
print_warning "System will restart Enigma2 in 5 seconds..."
for i in {5..1}; do
    echo -ne "Restarting in $i seconds...\r"
    sleep 1
done

print_status "Restarting Enigma2..."
echo "==================================="

# Restart Enigma2
if pgrep enigma2 > /dev/null; then
    killall -9 enigma2
    print_status "Enigma2 has been restarted"
else
    print_warning "Enigma2 process was not running"
fi

exit 0






























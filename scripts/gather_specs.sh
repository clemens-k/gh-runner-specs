#!/usr/bin/env bash
#
# Main script to gather runner specifications
# Automatically detects the platform and calls appropriate gathering scripts
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/common.sh"

# Allow override via command line argument or environment variable
PLATFORM="${1:-${PLATFORM:-$(detect_platform)}}"

print_header "HARDWARE INFORMATION"

# Call platform-specific hardware gathering script
case "$PLATFORM" in
  linux)
    bash "${SCRIPT_DIR}/gather_hardware_linux.sh"
    ;;
  macos)
    bash "${SCRIPT_DIR}/gather_hardware_macos.sh"
    ;;
  windows)
    bash "${SCRIPT_DIR}/gather_hardware_windows.sh"
    ;;
  *)
    echo "Error: Unknown platform '$PLATFORM'"
    echo "Supported platforms: linux, macos, windows"
    exit 1
    ;;
esac

print_header "SOFTWARE INFORMATION"

# Call platform-specific software gathering script
case "$PLATFORM" in
  linux)
    bash "${SCRIPT_DIR}/gather_software_linux.sh"
    ;;
  macos)
    bash "${SCRIPT_DIR}/gather_software_macos.sh"
    ;;
  windows)
    bash "${SCRIPT_DIR}/gather_software_windows.sh"
    ;;
  *)
    echo "Error: Unknown platform '$PLATFORM'"
    echo "Supported platforms: linux, macos, windows"
    exit 1
    ;;
esac

#!/usr/bin/env bash
#
# Gather software information on macOS systems
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/common.sh"

gather_os_info() {
  print_section "Kernel/OS Version"
  echo "Kernel Version:"
  uname -r
  echo ""
  echo "macOS Version:"
  sw_vers
  echo ""
  echo "Full uname:"
  uname -a
}

gather_installed_software() {
  print_section "Installed Software (Sample)"
  
  echo "Package managers:"
  which brew port 2>/dev/null || echo "None found"
  echo ""
  
  echo "Development tools:"
  for tool in gcc clang make cmake python3 node java docker git; do
    if which "$tool" &>/dev/null; then
      version=$(get_tool_version "$tool")
      echo "$tool: $(which $tool) - $version"
    fi
  done
  
  # xcodebuild separately as it exits with non-zero on --version
  if which xcodebuild &>/dev/null; then
    version=$(get_tool_version xcodebuild)
    echo "xcodebuild: $(which xcodebuild) - $version"
  fi
}

gather_environment() {
  print_section "Key Environment Variables"
  echo "HOME/USERPROFILE: $HOME"
  echo "PATH (first 500 chars): ${PATH:0:500}"
  echo "RUNNER_OS: ${RUNNER_OS:-N/A}"
  echo "RUNNER_ARCH: ${RUNNER_ARCH:-N/A}"
  echo "RUNNER_NAME: ${RUNNER_NAME:-N/A}"
  echo "RUNNER_TEMP: ${RUNNER_TEMP:-N/A}"
}

# Main execution
main() {
  gather_os_info
  echo ""
  gather_installed_software
  echo ""
  gather_environment
  echo ""
}

# Only run main if script is executed directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main
fi

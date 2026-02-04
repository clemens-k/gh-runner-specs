#!/usr/bin/env bash
#
# Gather software information on Windows systems
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/common.sh"

gather_os_info() {
  print_section "Kernel/OS Version"
  systeminfo | grep -E "OS Name|OS Version|System Type"
  echo ""
  echo "Windows Version Details:"
  cmd //c ver
}

gather_installed_software() {
  print_section "Installed Software (Sample)"
  
  echo "Development tools:"
  for tool in python node java docker git; do
    if which "$tool" &>/dev/null; then
      echo "$tool: $(which $tool)"
      version=$(get_tool_version "$tool")
      echo "$version"
    fi
  done
  
  echo ""
  echo "Chocolatey:"
  which choco &>/dev/null && choco --version || echo "Not installed"
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

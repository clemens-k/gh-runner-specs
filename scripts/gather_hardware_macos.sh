#!/usr/bin/env bash
#
# Gather hardware information on macOS systems
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/common.sh"

gather_cpu_info() {
  print_section "CPU Information"
  echo "CPU Model:"
  sysctl -n machdep.cpu.brand_string 2>/dev/null || system_profiler SPHardwareDataType | grep "Chip\|Processor"
  echo ""
  echo "CPU Count: $(sysctl -n hw.ncpu)"
  echo "Physical CPUs: $(sysctl -n hw.physicalcpu)"
  echo "Logical CPUs: $(sysctl -n hw.logicalcpu)"
}

gather_ram_info() {
  print_section "RAM Information"
  echo "Total RAM: $(($(sysctl -n hw.memsize) / 1024 / 1024 / 1024)) GB"
  vm_stat | head -10
}

gather_disk_info() {
  print_section "Disk Information"
  df -h / | tail -1
  echo ""
  echo "Disk usage summary:"
  df -h | grep -E "^/dev|Filesystem"
}

# Main execution
main() {
  gather_cpu_info
  echo ""
  gather_ram_info
  echo ""
  gather_disk_info
  echo ""
}

# Only run main if script is executed directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main
fi

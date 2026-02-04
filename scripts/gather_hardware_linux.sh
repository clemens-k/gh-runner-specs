#!/usr/bin/env bash
#
# Gather hardware information on Linux systems
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/common.sh"

gather_cpu_info() {
  print_section "CPU Information"
  echo "CPU Model:"
  lscpu | grep "Model name" || cat /proc/cpuinfo | grep "model name" | head -1
  echo ""
  echo "CPU Details:"
  lscpu | grep -E "Architecture|CPU\(s\)|Thread|Core|Socket|Vendor|MHz" || true
  echo ""
  echo "CPU Count: $(nproc)"
}

gather_ram_info() {
  print_section "RAM Information"
  free -h
  echo ""
  echo "Total RAM: $(free -h | awk '/^Mem:/ {print $2}')"
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

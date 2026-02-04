#!/usr/bin/env bash
#
# Gather hardware information on Windows systems
# Note: Uses PowerShell commands as wmic is deprecated in Windows Server 2025
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/common.sh"

gather_cpu_info() {
  print_section "CPU Information"
  powershell -Command "Get-CimInstance -ClassName Win32_Processor | Select-Object Name, NumberOfCores, NumberOfLogicalProcessors | Format-List"
}

gather_ram_info() {
  print_section "RAM Information"
  powershell -Command "Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object TotalPhysicalMemory | Format-List"
  systeminfo | grep "Total Physical Memory"
}

gather_disk_info() {
  print_section "Disk Information"
  powershell -Command "Get-CimInstance -ClassName Win32_LogicalDisk | Select-Object DeviceID, Size, FreeSpace | Format-List"
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

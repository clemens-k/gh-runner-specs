#!/usr/bin/env bash
#
# Save runner specifications to artifact files
# Usage: save_specs.sh <output_file> <runner_os> <arch> <platform>
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Arguments
OUTPUT_FILE="${1:-runner-specs.txt}"
RUNNER_OS="${2:-unknown}"
ARCH="${3:-unknown}"
PLATFORM="${4:-$(detect_platform)}"

# Create output directory if needed
OUTPUT_DIR="$(dirname "$OUTPUT_FILE")"
mkdir -p "$OUTPUT_DIR"

# Create the specification file header
cat > "$OUTPUT_FILE" << EOF
============================================
GITHUB ACTIONS RUNNER SPECIFICATIONS
============================================
Runner: $RUNNER_OS
Architecture: $ARCH
Platform: $PLATFORM
Collection Date: $(date)

EOF

# Append hardware information
echo "" >> "$OUTPUT_FILE"
echo "=== HARDWARE INFORMATION ===" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

case "$PLATFORM" in
  linux)
    echo "CPU:" >> "$OUTPUT_FILE"
    lscpu >> "$OUTPUT_FILE" 2>/dev/null || cat /proc/cpuinfo >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    echo "Memory:" >> "$OUTPUT_FILE"
    free -h >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    echo "Disk:" >> "$OUTPUT_FILE"
    df -h >> "$OUTPUT_FILE"
    ;;
  macos)
    echo "CPU:" >> "$OUTPUT_FILE"
    sysctl -a | grep -E "machdep.cpu|hw.cpu|hw.ncpu|hw.physicalcpu|hw.logicalcpu" >> "$OUTPUT_FILE" 2>/dev/null
    echo "" >> "$OUTPUT_FILE"
    echo "Memory:" >> "$OUTPUT_FILE"
    sysctl hw.memsize >> "$OUTPUT_FILE"
    vm_stat >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    echo "Disk:" >> "$OUTPUT_FILE"
    df -h >> "$OUTPUT_FILE"
    ;;
  windows)
    echo "CPU:" >> "$OUTPUT_FILE"
    powershell -Command "Get-CimInstance -ClassName Win32_Processor | Format-List" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    echo "Memory:" >> "$OUTPUT_FILE"
    powershell -Command "Get-CimInstance -ClassName Win32_ComputerSystem | Format-List" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    echo "Disk:" >> "$OUTPUT_FILE"
    powershell -Command "Get-CimInstance -ClassName Win32_LogicalDisk | Format-List" >> "$OUTPUT_FILE"
    ;;
esac

# Append software information
echo "" >> "$OUTPUT_FILE"
echo "=== SOFTWARE INFORMATION ===" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "Kernel/OS:" >> "$OUTPUT_FILE"
uname -a >> "$OUTPUT_FILE"

case "$PLATFORM" in
  linux)
    cat /etc/os-release >> "$OUTPUT_FILE" 2>/dev/null || true
    ;;
  macos)
    sw_vers >> "$OUTPUT_FILE" 2>/dev/null || true
    ;;
  windows)
    systeminfo >> "$OUTPUT_FILE" 2>/dev/null || true
    ;;
esac

echo "Specifications saved to: $OUTPUT_FILE"

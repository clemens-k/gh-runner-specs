# Runner Specification Scripts

This directory contains shell scripts for gathering hardware and software specifications from GitHub Actions runners (or any system).

## Overview

The scripts are organized to be modular, reusable, and executable both manually and within GitHub Actions workflows.

## Scripts

### Main Entry Points

- **`gather_specs.sh`** - Main script that automatically detects the platform and gathers all specifications
  ```bash
  # Auto-detect platform
  ./scripts/gather_specs.sh
  
  # Override platform
  ./scripts/gather_specs.sh linux
  ./scripts/gather_specs.sh macos
  ./scripts/gather_specs.sh windows
  ```

- **`save_specs.sh`** - Save specifications to a file for artifact generation
  ```bash
  ./scripts/save_specs.sh output.txt runner-name arch platform
  ```

### Platform-Specific Scripts

Hardware information gathering:
- **`gather_hardware_linux.sh`** - CPU, RAM, disk info for Linux
- **`gather_hardware_macos.sh`** - CPU, RAM, disk info for macOS
- **`gather_hardware_windows.sh`** - CPU, RAM, disk info for Windows (uses PowerShell)

Software information gathering:
- **`gather_software_linux.sh`** - OS version, installed tools for Linux
- **`gather_software_macos.sh`** - OS version, installed tools for macOS
- **`gather_software_windows.sh`** - OS version, installed tools for Windows

### Utilities

- **`common.sh`** - Shared utility functions (sourced by other scripts)
  - Platform detection
  - Tool version checking
  - Output formatting

## Manual Usage

### Quick Start

To gather and display all specifications for your current system:

```bash
cd /path/to/repo
./scripts/gather_specs.sh
```

### Gathering Specific Information

You can run individual scripts to gather only hardware or software information:

```bash
# Linux
./scripts/gather_hardware_linux.sh
./scripts/gather_software_linux.sh

# macOS
./scripts/gather_hardware_macos.sh
./scripts/gather_software_macos.sh

# Windows (Git Bash)
./scripts/gather_hardware_windows.sh
./scripts/gather_software_windows.sh
```

### Saving to File

To save specifications to a file:

```bash
./scripts/save_specs.sh my-system-specs.txt my-laptop amd64 linux
```

## GitHub Actions Usage

The scripts are designed to be called from the workflow YAML:

```yaml
- name: Gather Hardware Information
  shell: bash
  run: |
    echo "Runner OS: ${{ matrix.os }}"
    echo "Architecture: ${{ matrix.arch }}"
    echo "Platform: ${{ matrix.platform }}"
    echo ""
    ./scripts/gather_specs.sh ${{ matrix.platform }}

- name: Save Specifications to Artifact
  shell: bash
  run: |
    mkdir -p runner-specs
    ./scripts/save_specs.sh \
      runner-specs/${{ matrix.os }}-${{ matrix.arch }}.txt \
      ${{ matrix.os }} \
      ${{ matrix.arch }} \
      ${{ matrix.platform }}
```

## Requirements

### All Platforms
- Bash (pre-installed on Linux/macOS, Git Bash on Windows)

### Linux
- Standard utilities: `lscpu`, `free`, `df`, `uname`, etc.

### macOS
- Standard utilities: `sysctl`, `sw_vers`, `system_profiler`, etc.

### Windows
- Git Bash (included with Git for Windows)
- PowerShell (for hardware queries)

## Design Principles

1. **Modularity** - Each script focuses on a specific task
2. **Reusability** - Common functions are in `common.sh`
3. **Platform Independence** - Scripts handle platform-specific differences
4. **Standalone Execution** - Can be run manually for testing
5. **Error Handling** - Uses `set -euo pipefail` for robust error handling

## Development

When modifying these scripts:

1. Keep platform-specific logic in the appropriate platform script
2. Move common functionality to `common.sh`
3. Ensure scripts work both standalone and when sourced
4. Test on the target platform before committing
5. Update this README if adding new scripts or changing usage

## Testing

You can test scripts locally:

```bash
# Test main script
./scripts/gather_specs.sh

# Test individual components
bash -n scripts/*.sh  # Syntax check
shellcheck scripts/*.sh  # Linting (if available)

# Test on specific platform
PLATFORM=linux ./scripts/gather_specs.sh
```

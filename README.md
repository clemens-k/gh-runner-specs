# gh-runner-specs

Run github actions to collect data about available runners

## Overview

This repository contains a GitHub Actions workflow that gathers hardware and software specifications from GitHub Actions runners across different platforms and architectures. We collect only latest for each of and architecture which is supported.

## Supported Runners

The workflow tests the following [GitHub Actions runners](https://docs.github.com/en/actions/reference/runners/github-hosted-runners):

### Linux (AMD64)

- `ubuntu-latest`

### Linux (ARM64)

- `ubuntu-24.04-arm`

### Windows (AMD64)

- `windows-latest`

### Windows (ARM64)

- `win11-arm` is disabled, because action had to wait for over 30min for an available runner

### macOS (AMD64 - Intel)

- `macos-15-intel`

### macOS (ARM64 - Apple Silicon)

- `macos-latest`

## Collected Information

The workflow collects the following information from each runner:

### Hardware Information

- **CPU Model**: Processor name and specifications
- **CPU Count**: Number of physical and logical CPUs
- **RAM**: Total memory available
- **Disk Space**: Available disk space and storage details

### Software Information

- **Kernel Version**: Operating system kernel version
- **OS Release**: Detailed OS version information
- **Installed Software**: Sample of common development tools (gcc, python, node, java, docker, git, etc.)
- **Environment Variables**: Key environment variables set by GitHub Actions

## Usage

### Manual Script Execution

The repository includes standalone bash scripts that can be executed manually for testing or debugging:

```bash
# Gather all specifications for your system
./scripts/gather_specs.sh

# Gather only hardware information
./scripts/gather_hardware_linux.sh    # For Linux
./scripts/gather_hardware_macos.sh    # For macOS
./scripts/gather_hardware_windows.sh  # For Windows

# Gather only software information
./scripts/gather_software_linux.sh    # For Linux
./scripts/gather_software_macos.sh    # For macOS
./scripts/gather_software_windows.sh  # For Windows

# Save specifications to a file
./scripts/save_specs.sh output.txt system-name amd64 linux
```

See [scripts/README.md](scripts/README.md) for detailed documentation on manual script usage.

### Cross-Platform Compatibility

The workflow uses **bash scripts** for all platforms, which works because:

- **Linux runners**: Native bash support
- **macOS runners**: Native bash support (Unix-based)
- **Windows runners**: Git Bash is pre-installed on all GitHub-hosted Windows runners

All workflow steps explicitly use `shell: bash` to ensure consistent behavior across all platforms. The scripts automatically adapt their commands based on the detected platform (Linux, Windows, or macOS).

### Running the Workflow

The workflow can be triggered in two ways:

1. **Manual Trigger**: Go to the Actions tab in GitHub and manually trigger the "GitHub Actions Runner Specifications" workflow
2. **Automatic Trigger**: The workflow runs automatically on pushes to `main` or `copilot/**` branches

### Viewing Results

After the workflow completes:

1. Go to the Actions tab
2. Click on the latest workflow run
3. View the logs for each runner to see the specifications in the console output
4. Download the artifacts to get detailed specification files for each runner

Each runner uploads its specifications as an artifact named `runner-specs-{os}-{arch}` that is retained for 90 days.

## Repository Structure

```txt
.
├── .github/
│   └── workflows/
│       └── runner-specs.yml    # GitHub Actions workflow (calls scripts)
├── scripts/                     # Executable bash scripts
│   ├── README.md               # Detailed script documentation
│   ├── common.sh               # Shared utility functions
│   ├── gather_specs.sh         # Main entry point
│   ├── gather_hardware_*.sh    # Platform-specific hardware gathering
│   ├── gather_software_*.sh    # Platform-specific software gathering
│   └── save_specs.sh           # Save specifications to file
└── README.md                   # This file
```

The scripts are modular and can be executed independently or as part of the GitHub Actions workflow.

## Output Format

The workflow outputs information in two formats:

1. **Console Output**: Formatted text displayed in the workflow logs
2. **Artifact Files**: Detailed specification files (`.txt`) for each runner containing complete hardware and software information

## Example Output

```txt
============================================
HARDWARE INFORMATION
============================================

Runner OS: ubuntu-latest
Architecture: amd64
Platform: linux

--- CPU Information ---
CPU Model:
Model name: Intel(R) Xeon(R) Platinum 8370C CPU @ 2.80GHz
...

--- RAM Information ---
Total RAM: 7.0Gi
...

--- Disk Information ---
Filesystem      Size  Used Avail Use% Mounted on
/dev/root        84G   56G   28G  67% /
...
```

## License

MIT

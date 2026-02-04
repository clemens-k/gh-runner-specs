# identiy_runners
Run github actions to collect data about available runners

## Overview

This repository contains a GitHub Actions workflow that gathers hardware and software specifications from all available GitHub Actions runners across different platforms and architectures.

## Supported Runners

The workflow tests the following GitHub Actions runners:

### Linux (AMD64)
- `ubuntu-latest`
- `ubuntu-22.04`
- `ubuntu-20.04`

### Linux (ARM64)
- `ubuntu-24.04-arm`

### Windows (AMD64)
- `windows-latest`
- `windows-2022`
- `windows-2019`

### macOS (AMD64 - Intel)
- `macos-13`
- `macos-12`

### macOS (ARM64 - Apple Silicon)
- `macos-latest`
- `macos-14`

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

## Output Format

The workflow outputs information in two formats:

1. **Console Output**: Formatted text displayed in the workflow logs
2. **Artifact Files**: Detailed specification files (`.txt`) for each runner containing complete hardware and software information

## Example Output

```
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

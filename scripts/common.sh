#!/usr/bin/env bash
#
# Common utility functions for runner specification gathering
#

# Get the version of a tool, handling special cases like Java
get_tool_version() {
  local tool="$1"
  
  if ! which "$tool" &>/dev/null; then
    return 1
  fi
  
  if [[ "$tool" == "java" ]]; then
    # Java uses -version not --version
    "$tool" -version 2>&1 | head -1
  elif [[ "$tool" == "xcodebuild" ]]; then
    # xcodebuild exits with non-zero on --version, handle gracefully
    "$tool" -version 2>&1 | head -1 || echo "installed"
  else
    "$tool" --version 2>&1 | head -1
  fi
}

# Print a section header
print_section() {
  echo ""
  echo "--- $1 ---"
}

# Print a main header
print_header() {
  echo "============================================"
  echo "$1"
  echo "============================================"
  echo ""
}

# Detect the current platform
detect_platform() {
  case "$(uname -s)" in
    Linux*)
      echo "linux"
      ;;
    Darwin*)
      echo "macos"
      ;;
    CYGWIN*|MINGW*|MSYS*|MINGW32*|MINGW64*)
      echo "windows"
      ;;
    *)
      echo "unknown"
      ;;
  esac
}

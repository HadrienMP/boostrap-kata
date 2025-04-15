#!/bin/bash

set -euo pipefail

check_dependencies() {
    local dependencies=("nix" "git" "direnv")
    for dep in "${dependencies[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            echo "Error: $dep is not installed." >&2
            exit 1
        fi
    done
}

main() {
    check_dependencies
}

main

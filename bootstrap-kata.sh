#!/bin/bash

set -euo pipefail

check_dependencies() {
    local dependencies=("nix" "git" "direnv")
    for dep in "${dependencies[@]}"; do
        if ! command -v "$dep" &>/dev/null; then
            echo "Error: $dep is not installed." >&2
            exit 1
        fi
    done
    list_sandboxes
    exit 0
}

list_sandboxes() {
    if ! output=$(nix flake show gitlab:pinage404/nix-sandboxes 2>/dev/null); then
        echo "Error: Failed to retrieve sandboxes." >&2
        exit 1
    fi

    echo "Available Sandboxes:"
    echo "$output" | awk '/templates/{flag=1;next}/^$/{flag=0}flag' | sed 's/^[[:space:]]*//'
}

main() {
    check_dependencies
}

main

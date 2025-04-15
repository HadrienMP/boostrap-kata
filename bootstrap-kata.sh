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

sanitize_kata() {
    local kata="$1"
    # Convert to lowercase and remove illegal characters
    echo "$kata" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9._-]//g'
}

parse_arguments() {
    local sandbox=""
    local kata=""

    while [[ $# -gt 0 ]]; do
        case $1 in
            --sandbox)
                sandbox="$2"
                shift 2
                ;;
            --kata)
                kata="$2"
                shift 2
                ;;
            *)
                echo "Unknown option: $1" >&2
                exit 1
                ;;
        esac
    done

    if [[ -z "$sandbox" ]]; then
        read -p "Enter sandbox: " sandbox
    fi

    if [[ -z "$kata" ]]; then
        read -p "Enter kata: " kata
    fi

    kata=$(sanitize_kata "$kata")

    echo "Chosen Sandbox: $sandbox"
    echo "Sanitized Kata: $kata"
}

main() {
    parse_arguments "$@"
    check_dependencies
}

main

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
    echo "$kata" | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g' | sed 's/[^a-z0-9._-]//g'
}

generate_directory_name() {
    local sandbox="$1"
    local kata="$2"
    local date
    date=$(date +%Y-%m-%d)
    echo "${sandbox}-${kata}-${date}"
}

ensure_unique_directory() {
    local base_name="$1"
    local dir_name="$base_name"
    local counter=1

    while [[ -d "$dir_name" ]]; do
        dir_name="${base_name}-${counter}"
        ((counter++))
    done

    echo "$dir_name"
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
        list_sandboxes
        read -p "Enter sandbox: " sandbox
    else
        if ! nix flake show gitlab:pinage404/nix-sandboxes 2>/dev/null | grep -q "$sandbox"; then
            echo "Error: Sandbox '$sandbox' does not exist." >&2
            exit 1
        fi
    fi

    if [[ -z "$kata" ]]; then
        read -p "Enter kata: " kata
    fi

    kata=$(sanitize_kata "$kata")

    local base_dir
    base_dir=$(generate_directory_name "$sandbox" "$kata")
    local final_dir
    final_dir=$(ensure_unique_directory "$base_dir")

    echo "Final Directory Name: $final_dir"

}

main() {
    local sandbox=""
    local kata=""
    parse_arguments "$@"
    check_dependencies
}

main

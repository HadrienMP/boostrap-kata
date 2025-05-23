#!/bin/bash

set -euo pipefail

check_dependencies() {
    echo "Checking dependencies..." >/dev/tty
    local dependencies=("nix" "git" "direnv")
    for dep in "${dependencies[@]}"; do
        if ! command -v "$dep" &>/dev/null; then
            echo "Error: $dep is not installed." >&2
            exit 1
        fi
    done
}

list_sandboxes() {
    echo "Listing available sandboxes..." >/dev/tty
    if ! output=$(nix flake show gitlab:pinage404/nix-sandboxes 2>/dev/null); then
        echo "Error: Failed to retrieve sandboxes." >&2
        exit 1
    fi

    echo "Available Sandboxes:"
    echo "$output" | awk '/templates/{flag=1;next}/^$/{flag=0}flag' | sed 's/^[[:space:]]*//'
}

sanitize_kata() {
    echo "Sanitizing kata name..." >/dev/tty
    local kata="$1"
    # Convert to lowercase and remove illegal characters
    echo "$kata" | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g' | sed 's/[^a-z0-9._-]//g'
}

generate_directory_name() {
    echo "Generating directory name..." >/dev/tty
    local sandbox="$1"
    local kata="$2"
    local date
    date=$(date +%Y-%m-%d)
    echo "${sandbox}-${kata}-${date}"
}

ensure_unique_directory() {
    echo "Ensuring unique directory name..." >/dev/tty
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
    echo "Parsing arguments..." >/dev/tty

    local sandbox=""
    local kata=""

    while [[ $# -gt 0 ]]; do
        case $1 in
        --sandbox=*)
            sandbox="${1#*=}"
            shift
            ;;
        --kata=*)
            kata="${1#*=}"
            shift
            ;;
        *)
            echo "Unknown option: $1" >&2
            exit 1
            ;;
        esac
    done

    local available_sandboxes
    available_sandboxes=$(nix flake show gitlab:pinage404/nix-sandboxes 2>/dev/null | awk '/templates/{flag=1;next}/^$/{flag=0}flag' | sed 's/^[[:space:]]*//')

    if [[ -z "$sandbox" ]]; then

        echo "Available Sandboxes:" >/dev/tty
        echo "$available_sandboxes" >/dev/tty
        read -p "Enter sandbox: " sandbox
    fi

    if ! echo "$available_sandboxes" | grep -q "$sandbox"; then
        echo "Error: Sandbox '$sandbox' does not exist." >&2 >/dev/tty
        exit 1
    fi

    if [[ -z "$kata" ]]; then
        read -p "Enter kata: " kata
    fi

    kata=$(sanitize_kata "$kata")

    local base_dir
    base_dir=$(generate_directory_name "$sandbox" "$kata")
    local final_dir
    final_dir=$(ensure_unique_directory "$base_dir")

    echo "$final_dir $sandbox"

}

create_and_enter_directory() {
    echo "Creating and entering directory..." >/dev/tty
    local dir_name="$1"
    local sandbox="$2"

    echo "nix flake new --template \"gitlab:pinage404/nix-sandboxes#${sandbox}\" \"${dir_name}\"" >/dev/tty
    if ! nix flake new --template "gitlab:pinage404/nix-sandboxes#$sandbox" "$dir_name"; then
        echo "Error: Failed to create new flake in directory '$dir_name'." >&2
        exit 1
    fi

    if ! cd "$dir_name"; then
        echo "Error: Failed to enter directory '$dir_name'." >&2
        exit 1
    fi
}

initialize_git() {
    echo "Initializing Git repository..." >/dev/tty
    if ! git init; then
        echo "Error: Failed to initialize Git repository." >&2
        exit 1
    fi

    if ! git add .; then
        echo "Error: Failed to add files to Git." >&2
        exit 1
    fi

    if ! git commit -m "Initial commit"; then
        echo "Error: Failed to commit files to Git." >&2
        exit 1
    fi

    echo "Git repository initialized successfully with an initial commit." >/dev/tty
}
main() {
    local sandbox
    local kata
    local final_dir
    read final_dir sandbox <<<"$(parse_arguments "$@")"
    check_dependencies
    create_and_enter_directory "$final_dir" "$sandbox"
    initialize_git
    echo "Kata bootstrapped successfully!" >/dev/tty
    exit 0
}

main "$@"

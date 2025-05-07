#!/usr/bin/env bash
# shellcheck disable=2317

set -euo pipefail

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
ROOT_DIR="$(dirname "$DIR")"
SRC_DIR="${ROOT_DIR}/src/"

. "$SRC_DIR"/pure.sh

# -------------------------------
# Parse the arguments
# -------------------------------

test_long_form_arguments() {
	actual=$(parse_args \
		--kata=fizzbuzz \
		--template=clojure \
		2>&1)

	assertEquals \
		"success;clojure;fizzbuzz" \
		"$actual"
}
test_short_form_arguments() {
	actual=$(parse_args \
		-k=fizzbuzz \
		-t=clojure \
		2>&1)

	assertEquals \
		"success;clojure;fizzbuzz" \
		"$actual"
}
test_the_kata_is_normalized() {
	actual=$(parse_args \
		--kata="maRs Rover" \
		--template=clojure \
		2>&1)

	assertEquals \
		"success;clojure;mars-rover" \
		"$actual"
}
test_fails_and_displays_the_usage_when_the_kata_is_not_only_letters_and_spaces() {
	actual=$(parse_args \
		--kata="maRs R2over" \
		--template=clojure \
		2>&1)

	assertEquals \
		"failure;The kata name can only contain letters and spaces;$(show_help)" \
		"$actual"
}
test_missing_arguments() {
	actual=$(parse_args 2>&1)

	assertEquals "success;;" "$actual"
}
test_usage() {
	actual=$(parse_args --help 2>&1)

	assertEquals \
		"usage" \
		"$actual"
}

# -------------------------------
# Parse the templates
# -------------------------------
NIX_FLAKE_SHOW=$(
	cat <<'EOF'
{
  "templates": {
    "c": {
      "description": "C with formatting and test",
      "type": "template"
    },
    "clojure": {
      "description": "Clojure with formatting, linting and test",
      "type": "template"
    }
  }
}
EOF
)
PARSED_TEMPLATES="c;C with formatting and test
clojure;Clojure with formatting, linting and test"

test_parse_templates() {
	actual=$(parse_templates "$NIX_FLAKE_SHOW")
	assertEquals "$PARSED_TEMPLATES"
	"$actual"
}

# -------------------------------
# Print the templates
# -------------------------------
test_parse_templates() {
	actual=$(print_templates "$PARSED_TEMPLATES")
	assertEquals \
		"$(echo -e "${BWhite}[1]${Color_Off} ${Blue}c${Color_Off} - C with formatting and test
${BWhite}[2]${Color_Off} ${Blue}clojure${Color_Off} - Clojure with formatting, linting and test")" \
		"$actual"
}

# -------------------------------
# Get the template for its number
# -------------------------------
test_get_template() {
	actual=$(get_template 2 "$PARSED_TEMPLATES")
	assertEquals "clojure" "$actual"
}

# -------------------------------
# Make the commands
# -------------------------------
test_make_the_commands() {
	actual=$(make_the_commands clojure fizzbuzz 2024-12-31)
	assertEquals \
		"
set -x
nix flake new --template \"gitlab:pinage404/nix-sandboxes#clojure\" clojure-fizzbuzz-2024-12-31
cd clojure-fizzbuzz-2024-12-31
git init
git add --all
git commit -m \"chore: init\"
set +x" \
		"$actual"
}

# shellcheck disable=1091
. shunit2

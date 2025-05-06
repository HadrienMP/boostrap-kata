#!/usr/bin/env bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR"/pure.sh
. "$DIR"/style.sh
. "$DIR"/loader.sh

echo "

░▒█▀▀▄░▄▀▀▄░▄▀▀▄░█▀▀░▀█▀░█▀▀▄░█▀▀▄░▄▀▀▄░░░▒█░▄▀░█▀▀▄░▀█▀░█▀▀▄
░▒█▀▀▄░█░░█░█░░█░▀▀▄░░█░░█▄▄▀░█▄▄█░█▄▄█░░░▒█▀▄░░█▄▄█░░█░░█▄▄█
░▒█▄▄█░░▀▀░░░▀▀░░▀▀▀░░▀░░▀░▀▀░▀░░▀░█░░░░░░▒█░▒█░▀░░▀░░▀░░▀░░▀ 

"

parse_result=$(parse_args "$@")
success=$(echo "$parse_result" | get 1)
template=""
kata=""
case "$success" in
success)
	template=$(echo "$parse_result" | get 2)
	kata=$(echo "$parse_result" | get 3)
	;;
failure)
	echo "$parse_result" | get 2
	echo "$parse_result" | get 3
	exit 1
	;;
usage)
	echo "$parse_result" | get 2
	exit
	;;
esac

# -----------------------------
# Get the template
# -----------------------------
if [ -z "$template" ]; then
	shloader -l emoji_hour -m "Getting the list of sandboxes" -e "✅"
	nix_flake_show=$(nix flake show gitlab:pinage404/nix-sandboxes --json 2>/dev/null)
	end_shloader
	echo ""
	templates=$(parse_templates "$nix_flake_show")
	print_templates "$templates"
	echo ""
	read -rp "Choose a sandbox [1,2...] " template_number
	template=$(get_template "$template_number" "$templates")
	echo -e "✅ Using $template"
fi

# -----------------------------
# Get the kata
# -----------------------------
if [ -z "$kata" ]; then
	read -rp "Which kata ? " kata
	kata=$(normalize_kata "$kata")
	case "$(validate_kata "$kata" | get 1)" in
	failure)
		echo "$parse_result" | get 2
		exit 1
		;;
	esac
fi

commands=$(make_the_commands "$template" "$kata" "$(date +'%Y-%m-%d')")
echo "I will execute the following commands"
echo "$commands"
read -rp "Is this OK ? [Y,n] " go
case "$go" in
y | Y)
	eval "$commands"
	;;
*)
	exit
	;;
esac

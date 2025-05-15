#!/usr/bin/env bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR"/pure.sh
# . "$DIR"/style.sh
. "$DIR"/loader.sh

echo "

░▒█▀▀▄░▄▀▀▄░▄▀▀▄░▀█▀░█▀▀░▀█▀░█▀▀▄░█▀▀▄░▄▀▀▄░░░▒█░▄▀░█▀▀▄░▀█▀░█▀▀▄
░▒█▀▀▄░█░░█░█░░█░░█░░▀▀▄░░█░░█▄▄▀░█▄▄█░█▄▄█░░░▒█▀▄░░█▄▄█░░█░░█▄▄█
░▒█▄▄█░░▀▀░░░▀▀░░░▀░░▀▀▀░░▀░░▀░▀▀░▀░░▀░█░░░░░░▒█░▒█░▀░░▀░░▀░░▀░░▀

"

parse_result=$(parse_args "$@")
template=""
kata=""
parse_success=$(echo "$parse_result" | get 1 | head -n 1)
case "$parse_success" in
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
	show_help
	exit
	;;
esac

# -----------------------------
# Get the template
# -----------------------------
if [ -z "$template" ]; then
	shloader "Getting the list of sandboxes"
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

today=$(date +'%Y-%m-%d')
commands=$(make_the_commands "$template" "$kata" "$today")
eval "$commands"

echo -e "\n✅ All done, you can now do 'cd $template-$kata-$today'"
echo "✨ Happy coding!"

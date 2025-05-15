#!/usr/bin/env bash

set -euo pipefail

parse_args() {
	local kata=""
	local template=""
	for _ in "$@"; do
		case $1 in
		-k=* | --kata=*)
			kata="$(normalize_kata "${1#*=}")"
			validate_kata "$kata"
			shift
			;;
		-t=* | --template=*)
			template="${1#*=}"
			shift
			;;
		-h | --help)
			echo "usage"
			exit
			;;
		esac
	done

	echo "success;$template;$kata"
}

normalize_kata() {
	kata=$1
	kata=${kata// /-} # Replace spaces by dashes
	kata=${kata,,}    # To lower case
	echo "$kata"
}

validate_kata() {
	if [[ ! "$1" =~ ^[a-z\-]+$ ]]; then
		echo "failure;The kata name can only contain letters and spaces;$(show_help)"
		exit
	fi
}

BWhite='\033[1;37m' # White Bold
Blue='\033[0;34m'   # Blue
Yellow='\033[0;33m' # Yellow
Green='\033[0;32m'  # Green
Color_Off='\033[0m' # Text Reset

show_help() {
	echo -e "A command line tool to make it fast and easy to bootstrap your next kata.
It uses the beautifully crafted sandboxes at https://gitlab.com/pinage404/nix-sandboxes.
They come equiped with all the tools and examples you need to start coding right away without any hustle
It will create a folder with the name of the template, the kata name and the date. 
It will then init a git repository and make a first commit.

------------------------------
${BWhite}Usage: bootstrap-kata [options]${Color_Off}

Options:
${Green}-k=, --kata=\"the kata name\"${Color_Off}     the name of the kata (can only contain letters)
${Green}-t=, --template=template${Color_Off}          the name of the nix-sandboxes template you are choosing
${Green}-h, --help${Color_Off}                      to prompt this message

Examples:
${Green}bootstrap-kata ${Yellow}# will list the available templates and ask you to choose${Color_Off}
${Green}bootstrap-kata --template=clojure ${Yellow}# selects the clojure template and ask for the kata name${Color_Off}
${Green}bootstrap-kata --template=clojure --kata=\"mars rover\"${Color_Off}"
}

parse_templates() {
	echo "$1" | jq --raw-output ".templates | to_entries[] | \"\(.key);\(.value.description)\""
}

print_templates() {
	local number=1
	echo "$1" | while read -r line; do
		template=$(echo "$line" | get 1)
		description=$(echo "$line" | get 2)
		echo -e "${BWhite}[$number]${Color_Off} ${Blue}$template${Color_Off} - $description"
		number=$((number + 1))
	done
}

get_template() {
	local number=$1
	local parsed=$2
	echo "$parsed" | sed "${number}q;d" | get 1
}

make_the_commands() {
	template=$1
	kata=$2
	today=$3
	folder="$template-$kata-$today"

	echo "
set -x
nix flake new --template \"gitlab:pinage404/nix-sandboxes#$template\" $folder
cd $folder
git init
git add --all
git commit -m \"chore: init\"
set +x
"

}

# Gets a field from a chain split by ';'
# the first field is numbered 1
# call this by doing echo "toto;tata;titi" | get 2 # will return tata
get() {
	cut -d ';' -f "$1"
}

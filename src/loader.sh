#!/usr/bin/env bash
# https://github.com/Kaderovski/shloader
# me@kaderovski.com
set -euo pipefail
tput civis

loader=('🕛' '🕐' '🕑' '🕒' '🕓' '🕔' '🕕' '🕖' '🕗' '🕘' '🕙' '🕚')
# loader=('\ ' '| ' '/ ' '- ')

play_shloader() {
	while true; do
		for frame in "${loader[@]}"; do
			printf "\r%s" "${frame} ${message}"
			sleep "0.08"
		done
	done
}

shloader_pid=""

end_shloader() {
	kill "${shloader_pid}" &>/dev/null
	tput cnorm
	printf "\r✅"
	echo
}

shloader() {
	message=$1
	tput civis
	play_shloader &
	shloader_pid="${!}"
}

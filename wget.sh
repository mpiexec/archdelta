#!/bin/bash
#
# Sun, 12 Mar 2017 23:28:00

function usage {
	echo -e "Usage: $0 [path]"
	exit
}

function error {
	echo -e "--\nError :("
	exit
}

unset wdir
wlst=wget.txt
dldir=dl
repos=(community core extra multilib)

if [[ $# -gt 1 ]]; then
	usage
elif [[ $# -eq 1 ]]; then
	wdir="$1"
else
	wdir=out
fi

[[ ! -d "$wdir" ]] && usage

for r in ${repos[@]}
do
	pushd "${wdir}/${r}" &>/dev/null
	echo -e "=> `pwd`"
	while read url; do
		case ${url::1} in
		'#') continue ;;
		esac
		wget -c -q --show-progress --progress=bar:force:noscroll \
		-P "$dldir" "$url"
		if [[ $? -ne 0 ]]; then
			wget -nv --spider "$url"
			error
		fi
	done < $wlst
	popd &>/dev/null
done

echo -e "--\nAll ok!"

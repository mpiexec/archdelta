#!/bin/bash
#
# Sun, 12 Mar 2017 23:28:30

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
repos=(community core extra multilib)

if [[ $# -gt 1 ]]; then
	usage
elif [[ $# -eq 1 ]]; then
	wdir="$1"
else
	wdir=out
fi

[[ ! -d "$wdir" ]] && usage

for r in ${repos[@]}; do
	pushd "${wdir}/${r}" &>/dev/null
	echo "=> `pwd`"
	while read url; do
		case ${url::1} in
		'#') continue ;;
		esac
		wget -nv --spider "$url"
		if [[ $? -ne 0 ]]; then
			error
		fi
	done < $wlst
	popd &>/dev/null
done

echo -e "--\nAll ok!"

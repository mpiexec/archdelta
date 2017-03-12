#!/bin/bash
#
# Sun, 12 Mar 2017 23:48:44

set -e 

function usage {
	echo -e "Usage: $0 <list> <dir>"
	exit
}

function die {
	echo >&2 "$@"
	exit
}

function checkfile {
	if [[ ! -f "$1" ]]; then
		die "--: file \`$1' not found"
		exit
	fi
}

function checkdir {
	if [[ ! -d "$1" ]]; then
		die "--: dir \`$1' not found"
		exit
	fi
}

skiped=0

if [[ $# -ne 2 ]]; then
	usage
else
	lst="$1"
	dir="$2"
fi

checkfile "$lst"
checkdir "$dir"

while read item; do
	case ${item::1} in
	'#')
		skiped=1
		continue
		;;
	esac
	checkfile "${dir}/${item}"
	echo -e "ok: ${dir}/${item}"
done < "$lst" 

if (( !skiped )); then 
	echo -e "--\nAll ok!"
else
	echo -e "--\nSkiped:"
	grep ^# "$lst"
fi

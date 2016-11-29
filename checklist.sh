#!/bin/bash
#
# Thu, 16 Jun 2016 11:33:14

set -e 

function usage {
	cat<<-EOF
	usage: `basename $0` <list> <dir>
	EOF
	exit
}

function die {
	echo >&2 "$@"
	exit
}

[ $# -ne 2 ] && usage

list="$1"
dir="$2"

# check list
[ -f "$list" ] || die "list \`$list' not found"
# check dir
[ -d "$dir" ] || die "dir \`$dir' not found"

# main
while read item; do
	[ -f "${dir}/${item}" ] \
		&& echo "ok: ${dir}/${item}" \
		|| die "--: ${dir}/${item}"
done < "$list"

echo -e "--\nAll ok!"

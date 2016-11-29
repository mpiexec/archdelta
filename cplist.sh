#!/bin/bash
#
# Thu, 16 Jun 2016 11:33:17

set -e

function usage {
	cat<<-EOF
	usage: `basename $0` <list> <from> <to>
	EOF
	exit
}

function die {
	echo >&2 "$@"
	exit
}

[ $# -ne 3 ] && usage

list="$1"
from="$2"
to="$3"

# check list
[ -f "$list" ] || die "list \`$list' not found"
# check from
[ -d "$from" ] || die "dir \`$from' not found"
# check to
[ -d "$to" ] || die "dir \`$to' not found"
# check from=to
[ "$from" == "$to" ] && die "dirs \`$from' and \`$to' are equal"

# main
while read item; do
	[ -f "${from}/${item}" ] \
		|| die "--: file \`${from}/${item}' not found"
	cp "${from}/${item}" "${to}" \
		&& echo "ok: \`${from}/${item}' -> \`${to}'"
done < "$list"

echo -e "--\nAll ok!"

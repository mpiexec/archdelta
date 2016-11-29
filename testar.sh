#!/bin/bash
#
# Mon, 27 Jun 2016 14:40:57

set -e

function usage {
	cat<<-EOF
	USAGE: `basename $0` <dir>
	EOF
	exit
}

function die {
	echo -e >&2 $@
	exit
}

[ $# -ne 1 ] && usage

dir="$1"

# check dir
[ -d "$dir" ] || die "--: dir \`$dir' not found"

for f in "${dir}/"*".tar.xz"; do
	if ! tar tf "$f" &>/dev/null; then
		echo -e "--: $f"
	else
		echo -e "ok: $f"
	fi
done

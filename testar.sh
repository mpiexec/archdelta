#!/bin/bash
#
# Sat, 29 Apr 2017 20:32:05

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

# subshell `cmd1 | cmd2` used here
find $dir -type f -iname "*.tar.xz" | while read f; do
	tar tf "$f" &> /dev/null
	case $? in
	0)	echo -e "ok: $f"
		;;
	*)	echo -e "--: $f"
		exit 1
		;;
	esac
done

# check subshell exit code
[[ $? != 0 ]] && exit $?

# if all is ok
echo -e "--\nAll ok!"

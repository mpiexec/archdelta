#!/bin/bash
#
# Thu, 16 Jun 2016 11:33:19

set -e

outdir="out"
repos=(community core extra multilib)
#repos=(core multilib)
arch="x86_64"

function die {
	echo >&2 "$@"
	exit
}

function usage {
	cat <<-EOF
	usage: `basename $0` <dir1> <dir2>
	EOF
	exit
}

function packages {
	local tempd=$1 i
	find "$tempd" -type f -name 'desc' | sort | while read i
	do
		sed -n 2p "$i" | tee -a "${tempd}/packages.txt"
	done
}

# main
[ $# -ne 2 ] && usage

dir1="$1"
dir2="$2"

# check dir1
[ -d "$dir1" ] || die "dir \`$dir1' error"
# check dir2
[ -d "$dir2" ] || die "dir \`$dir2' error"
# check dir1=dir2
[ "$dir1" == "$dir2" ] && die "dirs \`$dir1' and \`$dir2' are equal"
# check outdir
[ -d "$outdir" ] \
	&& die "outdir \`$outdir' already exist" \
	|| { mkdir "$outdir"; \
		echo "${dir1} -> ${dir2}" >> "${outdir}/diff.log"; \
		echo "repos: ${repos[@]}" >> "${outdir}/diff.log"; \
		echo "arch: ${arch}" >> "${outdir}/diff.log"; }

# diff
for repo in ${repos[@]}; do
	mkdir "${outdir}/${repo}"
	tempd1=`mktemp -d`
	tempd2=`mktemp -d`
	tar xf "${dir1}/${repo}.db.tar.gz" -C "$tempd1"
	packages "$tempd1"
	tar xf "${dir2}/${repo}.db.tar.gz" -C "$tempd2"
	packages "$tempd2"

	# old files
	comm -23 "$tempd1/packages.txt" "$tempd2/packages.txt" \
						>> "${outdir}/${repo}/rm.txt"
	cat "${outdir}/${repo}/rm.txt" >> "${outdir}/rm.txt"

	# unchaged files
	comm -12 "$tempd1/packages.txt" "$tempd2/packages.txt" \
						>> "${outdir}/${repo}/cp.txt"
	cat "${outdir}/${repo}/cp.txt" >> "${outdir}/cp.txt"
	cat "${outdir}/${repo}/cp.txt" >> "${outdir}/${repo}/all.txt"

	# new files
	comm -13 "$tempd1/packages.txt" "$tempd2/packages.txt" \
						>> "${outdir}/${repo}/dl.txt"
	cat "${outdir}/${repo}/dl.txt" >> "${outdir}/dl.txt"
	cat "${outdir}/${repo}/dl.txt" >> "${outdir}/${repo}/all.txt"

	# wget files
	source .mirror.inc
	awk '{printf "'"${mirror}/"'%s\n", $0}' \
		<(comm -13 "$tempd1/packages.txt" "$tempd2/packages.txt") \
		>> "${outdir}/${repo}/wget.txt"

	rm -Rvf "$tempd1"
	rm -Rvf "$tempd2"
done

wc -l "${outdir}/"{cp,dl,rm}".txt"

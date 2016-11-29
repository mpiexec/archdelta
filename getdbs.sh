#!/bin/bash
#
# Thu, 16 Jun 2016 22:02:58

set -e

now=`date +"%Y.%m.%d"`
repos=(community core extra multilib)
files=(db files)
arch="x86_64"
log="urls.log"

function die {
	echo -e >&2 $@
	exit
}

function usage {
	cat<<-EOF
	usage: `basename $0`
	EOF
	exit
}

[ $# -ne 0 ] && usage

# check output dir
[ -d "${now}-${arch}" ] \
	&& die "dir \`${now}-${arch}' already exists" \
	|| mkdir "${now}-${arch}"

# main
for repo in ${repos[@]}; do
	source .mirror.inc
	for file in ${files[@]}; do
		wget "${mirror}/${repo}.${file}.tar.gz" \
			-P "${now}-${arch}"
		echo "${mirror}/${repo}.${file}.tar.gz" \
			>> "${now}-${arch}/${log}"
		ln -s "${repo}.${file}.tar.gz" "${now}-${arch}/${repo}.${file}"
	done
done

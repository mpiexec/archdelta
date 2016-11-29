#!/bin/bash
#
# Tue, 29 Nov 2016 22:21:03

wdir=out
wgetlst=wget.txt
dldir=dl
repos=(community core extra multilib)

for r in ${repos[@]}
do
	pushd "${wdir}/${r}"
	pwd
	wget -q --show-progress --progress=bar:force:noscroll -i $wgetlst \
		-P $dldir
	popd
done

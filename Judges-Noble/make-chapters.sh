#!/bin/bash

# make chapter files for printing Judges-Noble

for each in $(seq 1 20)
	do tstr="$(grep -P "^== " ch$each.adoc)"
	chapter=${tstr##*s }; chapter=${chapter%%:*}
	title="Judges_$chapter"
	if ! [ -f $title.adoc ]
		then printf "create file $title.adoc\n"
			printf "= Judges $chapter\nBy the Rev. Samuel Nobel - 1856\n\n\n" >$title.adoc
		fi
	printf "include::{docdir}/Judges-Noble/ch$each.adoc[]\n" >>$title.adoc
done

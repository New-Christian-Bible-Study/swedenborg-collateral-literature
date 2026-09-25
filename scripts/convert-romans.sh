#!/bin/bash


# reference: grep -oPh "\s[ivxlc]{2,}\.?,\s" text/* |sed -E 's/\s([ivxlc]+).*/\1/g' |sort -u |sed '/civil/d' |while read roman; do arabic=$(roman2arabic.sh $roman); ssed -iR 's/'" ${roman}[,.]"'/ '"${arabic},"'/g' text/Sermons_on_the_Ten_Commandments_Volume_1-Acton.adoc; done

ls -1 ../text/*.adoc |
	while read title; do
		printf "$title "
		grep -oP "\s[ivxlc]{2,}[.,]+\s" $title |
		sed -E 's/\s([ivxlc]+).*/\1/g' |sort -u |sed '/civil/d' |
#	read -p "ENTER to proceed" </dev/tty
		while read roman; do
			printf "."
			arabic=$(roman2arabic.sh $roman);
			ssed -iR 's/ '"${roman}[,.]"'/ '"${arabic},"'/g' $title
		done
	printf "\n"
	done


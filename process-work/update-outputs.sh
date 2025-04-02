#!/bin/bash

# scan timestamps of all .adoc files
# for each of PDF EPUB
# if exist, compare datestamps, else create
# 	if adoc last modified, create a new one

sourcedir='../text'
pdfdest='../pdfs'
epubdest='../epubs'

[ -f /tmp/adoc.log ] && rm /tmp/adoc.log

createpdf () {
#	echo "Creating $pdfdest/$title.pdf from $sourcedir/$title.adoc"
	printf "...p"
	asciidoctor-pdf -D $pdfdest $sourcedir/$sourcefile 2>>/tmp/adoc.log && printf "df "
	
}

createepub () {
#	echo "Creating $epubdest/$title.pdf from $sourcedir/$title.adoc"
	printf "...e"
	asciidoctor-epub3 -D $epubdest $sourcedir/$sourcefile 2>/dev/null && printf "pub "
}



[ -d $pdfdest ] || { echo "Directory $pdfdest not found"; exit; }
[ -d $sourcedir ] || { echo "Directory $sourcedir not found"; exit; }
[ -d $epubdest ] || { echo "Directory $epubdest not found"; exit; }

ls -1 $sourcedir | 
	while read sourcefile; do
		title=${sourcefile%.*};
		printf "$title "
		[ -f $pdfdest/$title.pdf ] || createpdf
		[ -f $epubdest/$title.epub ] || createepub
		sourcetime=$(stat -c %Y $sourcedir/$t) 2>/dev/null
		pdftime=$(stat -c %W $pdfdest/$t) 2>/dev/null
		epubtime=$(stat -c %W $epubdest/$t) 2>/dev/null
		printf ".s=$sourcetime.p=$pdftime.e=$epubtime "
		[[ $sourcetime -gt $pdftime ]] && createpdf
		[[ $sourcetime -gt $epubtime ]] && createepub
		printf "\n"
	done

exit

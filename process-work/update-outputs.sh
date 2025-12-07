#!/bin/bash

# scan timestamps of all .adoc files
# for each of PDF EPUB
# if exist, compare datestamps, else create
# 	if adoc last modified, create a new one

sourcedir='../text'
destbase='../../publish'
remotebase='/mnt/gdrive/NCBS/'
pdfdest=$destbase/pdfs
epubdest=$destbase/epubs
mobidest=$destbase/mobis

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
	printf "...m"
	ebook-convert $epubdest/$title.epub $mobidest/$title.mobi >/dev/null && printf "obi"
	
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
		sourcetime=$(stat -c %Y $sourcedir/$title.adoc) 2>/dev/null
		pdftime=$(stat -c %Y $pdfdest/$title.pdf) 2>/dev/null
		epubtime=$(stat -c %Y $epubdest/$title.epub) 2>/dev/null
		printf ".s=$sourcetime.p=$pdftime.e=$epubtime "
		[[ $sourcetime -gt $pdftime ]] && createpdf
		[[ $sourcetime -gt $epubtime ]] && createepub
		printf "\n"
	done

[ -d $remotebase ] && rsync -av $destbase/ $remotebase |tee /tmp/rsynclog

exit

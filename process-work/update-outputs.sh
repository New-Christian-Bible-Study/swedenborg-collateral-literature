#!/bin/bash

# scan timestamps of all .adoc files
# for each of PDF EPUB
# if exist, compare datestamps, else create
# 	if adoc last modified, create a new one

#localbase=$(pwd)
localbase="$(dirname $(readlink -f ${BASH_SOURCE[0]}))"

remotebase='/mnt/gdrive/NCBS/'
sourcedir=$localbase/../text
destbase=$localbase/../../publish
pdfdest=$destbase/pdfs
epubdest=$destbase/epubs
mobidest=$destbase/mobis

modstoupload=false

[ -f /tmp/adoc.log ] && rm /tmp/adoc.log

createpdf () {
#	echo "Creating $pdfdest/$title.pdf from $sourcedir/$title.adoc"
	printf "...p"
	asciidoctor-pdf -D $pdfdest $sourcedir/$sourcefile 2>>/tmp/adoc.log && printf "df "
	modstoupload=true
	
}

createepub () {
#	echo "Creating $epubdest/$title.pdf from $sourcedir/$title.adoc"
	printf "...e"
	asciidoctor-epub3 -D $epubdest $sourcedir/$sourcefile 2>>/tmp/adoc.log && printf "pub "
	printf "...m"
	ebook-convert $epubdest/$title.epub $mobidest/$title.mobi >>/tmp/adoc.log && printf "obi"
	modstoupload=true
	
}

#echo "SCRIPT_PATH: $(readlink -f ${BASH_SOURCE[0]})"
#echo "script pathonly: $(dirname $(readlink -f ${BASH_SOURCE[0]}))"
#echo "pwd: $(pwd)" >&2
#echo "par0: $0" >&2
#echo "target: $(pwd)/$0" >&2
#echo "SCRIPT_PATH: ${BASH_SOURCE[0]}" >&2
echo "localbase: $localbase" >/tmp/adoc.log
echo "sourcedir: $sourcedir" >>/tmp/adoc.log



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

if $modstoupload
	then printf "....probing $remotebase...."
	[ -d $remotebase ] && rsync -av $destbase/ $remotebase |tee /tmp/rsynclog
else echo "No Updates Found"
fi

wc -l /tmp/adoc.log /tmp/rsynclog

exit

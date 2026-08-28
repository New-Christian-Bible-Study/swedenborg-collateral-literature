#!/bin/bash

# scan timestamps of all .adoc files
# for each of PDF EPUB
# if exist, compare datestamps, else create
# 	if adoc last modified, create a new one

[ -f /tmp/adoc.log ] && rm /tmp/adoc.log
#declare -i modstoupload=0

#localbase=$(pwd)
remotebase='/mnt/gdrive/NCBS/'
scriptdir="$(dirname $(readlink -f ${BASH_SOURCE[0]}))"	### the location of this script file
### docubase here is /ssd1/NCBS/swedenborg-collateral-literature -- which is the VSCode Workkspace
### and is used within VSCode as the {docdir} reference for 'include' files
docubase=$(realpath $scriptdir/../)	### needed for asciidoctor attribute='docdir:$docubase'
adoc_attrib_docdir="docdir=$docubase"
sourcedir=$docubase/text
destdir=$(realpath $docubase/../publish)
pdfdest=$destdir/pdfs
epubdest=$destdir/epubs
mobidest=$destdir/mobis

echo "scriptdir: $scriptdir" >>/tmp/adoc.log
echo "docubase: $docubase" >>/tmp/adoc.log
#echo "sourcedir: $sourcedir"
#echo "destdir: $destdir"
echo "adoc_attrib_docdir: $adoc_attrib_docdir" >>/tmp/adoc.log
#echo "pdfdest: $pdfdest"


createpdf () {
#	echo "Creating $pdfdest/$title.pdf from $sourcedir/$title.adoc"
	printf "...p"
#	docsource=$(readlink -f $sourcedir/$sourcefile)
echo "docubase: $docubase" >>/tmp/adoc.log
echo "attrib: $adoc_attrib_docdir" >>/tmp/adoc.log
echo "pdfdest: $pdfdest" >>/tmp/adoc.log
echo "d/f: $sourcedir/$sourcefile" >>/tmp/adoc.log
echo "docsource: $docsource" >>/tmp/adoc.log
#echo "readlink: $(readlink $sourcedir/$sourcefile)"
#echo "realpath: $(realpath $(readlink $sourcedir/$sourcefile))"
	asciidoctor-pdf -B $docubase --attribute="$adoc_attrib_docdir" -D $pdfdest -o $title.pdf $docsource 2>>/tmp/adoc.log && printf "df "
	
}

createepub () {
#	echo "Creating $epubdest/$title.pdf from $sourcedir/$title.adoc"
	printf "...e"
#	docsource=$(readlink $sourcedir/$sourcefile)
	asciidoctor-epub3 -B $docubase -a "$adoc_attrib_docdir" -D $epubdest -o $title.epub $docsource 2>>/tmp/adoc.log && printf "pub "
	printf "...m"
	ebook-convert $epubdest/$title.epub $mobidest/$title.mobi >>/tmp/adoc.log && printf "obi"
	
}

#echo "SCRIPT_PATH: $(readlink -f ${BASH_SOURCE[0]})"
#echo "script pathonly: $(dirname $(readlink -f ${BASH_SOURCE[0]}))"
#echo "pwd: $(pwd)" >&2
#echo "par0: $0" >&2
#echo "target: $(pwd)/$0" >&2
#echo "SCRIPT_PATH: ${BASH_SOURCE[0]}" >&2
#echo "sourcedir: $sourcedir" >>/tmp/adoc.log



[ -d $pdfdest ] || { echo "Directory $pdfdest not found"; exit; }
[ -d $sourcedir ] || { echo "Directory $sourcedir not found"; exit; }
[ -d $epubdest ] || { echo "Directory $epubdest not found"; exit; }

declare -i modstoupload=1
## I honestly don't understand why I've been unable to set this on condition when intilized as 0 ????

ls -1 $sourcedir | 
	while read sourcefile; do
		docsource=$(readlink -f $sourcedir/$sourcefile) ### accommodation for symlinks in the $sourcedir .../text/ 
		docfile=${docsource##*/}
		doctitle=${docfile%.*}
#		title=$doctitle
		title=${sourcefile%.*};
		printf "$title "
		[ -f $pdfdest/$title.pdf ] || createpdf
		[ -f $epubdest/$title.epub ] || createepub
#		sourcetime=$(stat -c %Y $sourcedir/$title.adoc) 2>/dev/null
		sourcetime=$(stat -c %Y $docsource) 2>/dev/null
		pdftime=$(stat -c %Y $pdfdest/$title.pdf) 2>/dev/null
		epubtime=$(stat -c %Y $epubdest/$title.epub) 2>/dev/null
		printf ".s=$sourcetime.p=$pdftime.e=$epubtime "
		if [ $sourcetime -gt $pdftime ]; then createpdf; modstoupload=$((modstoupload+1)); fi
		if [ $sourcetime -gt $epubtime ]; then createepub; fi #((modstoupload+=1))
		printf "\n"
	done
echo "mods to upload: $modstoupload"


if [ $modstoupload -gt 0 ]
	then printf "....probing $remotebase...."
	[ -d $remotebase ] && rsync -av $destdir/ $remotebase |tee /tmp/rsynclog
else echo "No Updates Found"
fi

exit

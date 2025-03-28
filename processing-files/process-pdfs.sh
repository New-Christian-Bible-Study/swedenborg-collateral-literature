#!/bin/bash

#biblist='./import-bib.list'
biblist='./import-lit-pdfs.list'
destdir='../'
oldIFS="$IFS"
IFS='!'

cat $biblist |
	while read src titl notes author
		do 
			archive="${src// /_}"
			pen="${author%%, *}"
			title="${titl// /_}"
			target="${destdir}/${title}-${pen}"
			printf "$target .... "
			if mkdir ${target}
				then curl -s "$archive" >${destdir}/source.pdf && \
				pdf2txt -o $target/${title}-${pen}.txt ${destdir}/source.pdf
				echo "succeeded"
			else echo "failed / pre-exists"
			fi
			sleep 20s
		done

IFS="$oldIFS"
exit



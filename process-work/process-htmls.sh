#!/bin/bash

### this script, and the list of html sources, have not been processed.
### it's long (94 titles), and much - but not all! - of it looks to be ?off-topic?

#biblist='./import-bib.list'
biblist='./import-lit-htmls.list'
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
				then lynx -dump "$src" >$target/${title}-${pen}.asc && \
				echo "succeeded"
			else echo "failed / pre-exists"
			fi
			sleep 20s
		done

IFS="$oldIFS"
exit



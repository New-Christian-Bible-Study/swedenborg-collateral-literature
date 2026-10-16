#!/bin/bash

# specifically for Kings-Bruce,
# to copy Chapter_Template into each King/Chapter 
# and modify template according to pre-existing 'chapter-mapping.table' files
# which associate the printed book chapters with the scriptural book chapters

# chapter-mapping.tables:
# ch3.adoc        1 Kings 3:1-14.
# ch4.adoc        1 Kings 3:27.
# ch5.adoc        2 Kings 4:21.
# ch6.adoc        1 Kings 5

# $KING/chapter-mapping.table

# └─$ grep -F '$' Chapter_Template 
# = The Reign of $KING - $BOOK $SCHAP
# include::{docdir}/Kings-Bruce/$KING/ch$BCHAP.adoc[]
# include::./ch$BCHAP.adoc[]

project_path='/ssd1/NCBS/swedenborg-collateral-literature/Kings-Bruce'
chapter_template="$project_path/Chapter_Template"
chapter_map='chapter-mapping.table'

echo "project_path: $project_path"

for king in Saul David Solomon;
	do rm $king/*^*_*.adoc ########################## DANGER ============== deleting pre-existing files
		cat $project_path/$king/$chapter_map |
		while read bchapfile unit book cverse;
			do bchap=${bchapfile%.adoc}; bchap=${bchap#ch}
			cvserse=${cvserse%.}; schap=${cverse%%:*};
			target="${king}/${unit}^${book}_${schap}.adoc"
			if [ -f $target ]
				then echo "adding to $target"
#					sed -i 's/\/\/:toc/:toc/' $target
					sed -i 's/\/\/:toc/:toc/;/ENDLISTA/iadda '"$bchapfile[]"'' $target
					sed -i '/ENDLISTB/iaddb '"$bchapfile[]"'' $target
				else cp $chapter_template $target
					sed -i 's/KING/'"$king"'/g;s/BOOK/'"$unit $book"'/g;s/SCHAP/'"$schap"'/g;s/BCHAP/'"$bchap"'/g' $target
			fi
			done
	done
echo "!!! NOTE: within each King, search for 'adda' and 'addb' instances of a second include for the scriptural chapter"
echo "and use VSCode to copy/replace these; and possibly insert page breaks, etc. between includes."
exit


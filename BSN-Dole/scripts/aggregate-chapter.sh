#!/bin/bash
#
# script to reaggregate BSN Chapters into new order
#
# presuming to run this script from BSN_Dole
# script resides in BSN_Dole/scripts

source_directory='disaggregants'

front_matter="Edited and Printed by NCBS + \nfrom best available representations of original manuscript.\n\n[.text-right]\nLast Revised {docdate}\n"


if [ $1 -ge 2 ]; then chapter_number=$1
	else echo "script requires numeric chapter number on command line"; exit
fi

chapter_number=$1
title_number=$((chapter_number-1))
output_file="Chapter_$chapter_number.adoc"
chapter_directory=$(ls -1d $source_directory/$chapter_number:*)
chapter_title=${chapter_directory#$source_directory/}
# sample: Title: 53:THE DIVISION OF THE LAND — Joshua 18:1-10
bible_ref=${chapter_title##*$'\u2014' }
chapter_name=${chapter_title% $'\u2014'*}
chapter_name=${chapter_name#*:}
title=$(title_case $chapter_name)

echo "Reading: $chapter_directory into: ./$output_file"
#echo "Title: $chapter_title"
#echo "Title name: $chapter_name"
echo "Title: $title"
echo "Bible reference: $bible_ref"

# create and write the output chapter file:
printf "= Bible Study Notes &#8212; Lesson $title_number\n" >"$output_file"
printf "By Anita S. Dole\n\n" >>"$output_file"
#printf "\n\n:title: $title\n\n" >>"$output_file"
#printf ":bibref: $bible_ref\n\n" >>"$output_file"
#printf "\n\n== {title}\n\n" >>"$output_file"
#printf "*Bible References:* {bibref}\n\n" >>"$output_file"
printf "\n\n== $title\n\n" >>"$output_file"
printf "*Bible References:* $bible_ref\n\n" >>"$output_file"

printf "_This is a lesson excerpted from The Dole Bible Study Notes. There are more than 150 of these lessons, covering many of the great stories in the Bible. They were designed for use in Sunday Schools, but they're good for all ages — for self-study, for parents to use in home devotions, and for pastors and teachers. Here's a link to more information about them._\n\n---" >>"$output_file"

echo -ne ".Contents\n.*Contents:*\n----\n1. Introduction\n2. Doctrinal Points\n3. Basic Correspondences\n4. Notes for Parents\n5. For Young Children\n6. For Older Children\n7. For Young Teens\n8. For Older Teens\n9. For Adults\n10. From Swedenborg's Writings\n11. Suggested Questions\n----\n\n" >>"$output_file"




# finding this: could be tricky:
# printf "\ninclude::./template-attributes.adoc[]\n" >>"$output_file"
# printf "\n\nadditional content belongs here\n\n" >>"$output_file"
# printf "\n\n$front_matter\n\n" >>"$output_file"

echo -ne "---\n" >>"$output_file"
cat "$chapter_directory/INTRO.txt" >>"$output_file"
echo -ne "---\n" >>"$output_file"
cat "$chapter_directory/Doctrinal Points.txt" >>"$output_file"
echo -ne "---\n" >>"$output_file"
cat "$chapter_directory/Basic Correspondences.txt" >>"$output_file"
echo -ne "---\n" >>"$output_file"
cat "$chapter_directory/Notes for Parents.txt" >>"$output_file"
echo -ne "---\n" >>"$output_file"
cat "$chapter_directory/Primary.txt" >>"$output_file"
echo -ne "---\n" >>"$output_file"
cat "$chapter_directory/Junior.txt" >>"$output_file"
echo -ne "---\n" >>"$output_file"
cat "$chapter_directory/Intermediate.txt" >>"$output_file"
echo -ne "---\n" >>"$output_file"
cat "$chapter_directory/Senior.txt" >>"$output_file"
echo -ne "---\n" >>"$output_file"
cat "$chapter_directory/Adult.txt" >>"$output_file"
echo -ne "---\n" >>"$output_file"
cat "$chapter_directory/From the Writings of Swedenborg.txt" >>"$output_file"
echo -ne "---\n" >>"$output_file"
cat "$chapter_directory/Suggested Questions on the Lesson.txt" >>"$output_file"


echo "Done"
exit

Normal section order:
INTRO	
Doctrinal Points
Notes for Parents
Primary
Junior
Intermediate
Basic Correspondences
Senior
Adult
From the Writings of Swedenborg
Suggested Questions on the Lesson



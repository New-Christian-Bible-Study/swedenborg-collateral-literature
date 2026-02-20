#!/bin/bash
#
# script to reaggregate BSN Chapters into new order
#

source_directory='disaggregants'

if [ $1 -ge 2 ]; then chapter_number=$1
	else echo "script requires numeric chapter number on command line"; exit
fi

chapter_number=$1
output_file="Chapter_$chapter_number.adoc"
chapter_directory=$(ls -1d $source_directory/$chapter_number:*)
chapter_title=${chapter_directory#$source_directory/}

echo "Reading: $chapter_directory into: ./$output_file"
echo "Title: $chapter_title"

printf "= BSN $chapter_title\n" >"$output_file"
# finding this: could be tricky:
# printf "\ninclude::./template-attributes.adoc[]\n" >>"$output_file"
printf "\n\nadditional content belongs here\n\n" >>"$output_file"
cat "$chapter_directory/INTRO.txt" >>"$output_file"
cat "$chapter_directory/Doctrinal Points.txt" >>"$output_file"
cat "$chapter_directory/Basic Correspondences.txt" >>"$output_file"
cat "$chapter_directory/Notes for Parents.txt" >>"$output_file"
cat "$chapter_directory/Primary.txt" >>"$output_file"
cat "$chapter_directory/Junior.txt" >>"$output_file"
cat "$chapter_directory/Intermediate.txt" >>"$output_file"
cat "$chapter_directory/Senior.txt" >>"$output_file"
cat "$chapter_directory/Adult.txt" >>"$output_file"
cat "$chapter_directory/From the Writings of Swedenborg.txt" >>"$output_file"
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



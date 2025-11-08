#!/bin/bash
#
# script to reaggregate BSN Chapters into Section files
# i.e. Primary, Junior, Intermediate, Senior, Adult storylines
#
source_directory='disaggregants'
chapter_number=0
chapter_name=""
chapter_file=/dev/null
chapter_directory="./"
section_name=""
section_file=/dev/null
current_line=0
line_contents=""

target_section="Adult"
output_file="BSN-Adult.adoc"
printf "= Bible Study Notes - Adult series\nAnita Dole\n" >"$output_file"
printf "\n\nadditional content belongs here\n\n" >>"$output_file"

# sequential chapter list
#read -p "Scanning chapters in $source_directory" </dev/tty
ls -1 "$source_directory" |sort -n \
	|while read chapter
	do printf "\n\n== $chapter\n\n" >>"$output_file"
		[[ -f "$source_directory/$chapter/$target_section.txt" ]] && \
			cat "$source_directory/$chapter/$target_section.txt" >> "$output_file"
		done
echo "Done"
exit




#
read -p "Reading lines from $end_line" </dev/tty

[[ -d "$output_directory" ]] && rm -rf "$output_directory"	#wipe the slate clean for fresh start
mkdir "$output_directory"

read -p "Writing directories and files to $output_directory" </dev/tty

while IFS= read -r line_contents; do
#	echo "** $line_contents"
	case ${line_contents:0:3} in
		"== " ) start_new_chapter ;;
		"===" ) start_new_section ;;
		esac
	echo "$line_contents" >>"$chapter_file"
	echo "$line_contents" >>"$section_file"
	done <"$source_file"

echo "Done"
exit



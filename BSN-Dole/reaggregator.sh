#!/bin/bash
#
# script to reaggregate BSN Chapters into Section files
# i.e. Primary, Junior, Intermediate, Senior, Adult storylines
#

source_directory='disaggregants'
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



#!/bin/bash
#
# script to disaggregate BSN_Full.adoc into
# Chapter Directories, sequentially numbered for reconstruction,
# each of which contains a file for the entire Chapter material,
# and files for each of the separated Sections.
# Good Luck.
####
#### !!!! ATTENTION: later (2/19/26) discovered small trouble:
#### the final section files "Suggested Questions ..." contain an errant trailing line:
#### of the next chapter: == DEBORAH AND BARAK — Judges 4 ... in the trial run of Chapter 53
####
#### !!!! this script has not been corrected for that trouble -- but its output has
##--
##-- !! also note that the original disaggregation generated 1:INTRO
##-- during 2026 processing for output, we're going with 0:Intro and 1:The_Creation ...
#
source_file='BSN_Full.adoc'
practice_file='../process-work/Dole_Study_Chapter.adoc'
output_directory='disaggregants'
chapter_number=0
chapter_name=""
chapter_file=/dev/null
chapter_directory="./"
section_name=""
section_file=/dev/null
current_line=0
line_contents=""
end_line=$(wc -l $source_file)


start_new_chapter () {
	chapter_number=$((chapter_number+1))
	chapter_name="${line_contents#== }"
	chapter_directory="$output_directory/$chapter_number:$chapter_name"
	chapter_file="$chapter_directory/$chapter_number:$chapter_name.adoc"
#	[[ -d "$chapter_directory" ]] && rm -rf "$chapter_directory"	#replace any existing chapter directory
	mkdir "$chapter_directory"
	printf "\n" >"$chapter_file"
	echo "$chapter_directory"
}


start_new_section () {
	section_name="${line_contents#=== }"
	section_file="$chapter_directory/$section_name.txt"
	printf "\n" >"$section_file"
}

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



#!/bin/bash
# with a bash for loop
# cd concatenate_source
cd concatenate_source
for f in ./*.mp4; do echo "file '$f'" >> ./mylist.txt; done
cd ../
# cd ../
# cmd="ffmpeg -f concat -i concatenate_source/mylist.txt -c copy concatenated_dest/output.mp4"
# echo $cmd
# $cmd

# or with printf
# printf "file '%s'\n" ./*.wav > mylist.txt
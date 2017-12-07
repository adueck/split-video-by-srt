#!/bin/bash

read -e -p "Enter name of subtitle file: " subtitleFile
read -e -p "Enter name of video file to cut: " fileToCut 
fileName=$(basename "$fileToCut")
fileExt="${fileName##*.}"
fileName="${fileName%.*}"

if [ -f "$subtitleFile" ] 
then
  i=1
  egrep "[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}" "$subtitleFile" | while read -r line ; do
   startTime=`echo $line | egrep -o "^[0-9]{2}:[0-9]{2}:[0-9]{2},[0-9]{3}"`
   endTime=`echo $line | egrep -o " [0-9]{2}:[0-9]{2}:[0-9]{2},[0-9]{3}"`
   startTimeForFfmpeg=`echo $startTime | sed 's/,/./'`
   echo "Cut no $i"
   startDate=$(date -u -d "$startTime" +"%s.%N")
   endDate=$(date -u -d "$endTime" +"%s.%N")
   timeDiff=$(date -u -d "0 $endDate sec - $startDate sec" +"%H:%M:%S.%N")
   echo "Will start at $startTimeForFfmpeg and go $timeDiff"
   ffmpeg -i $fileToCut -ss $startTimeForFfmpeg -t $timeDiff -async 1 -strict -2 $fileName${i}.$fileExt
   i=$[i+1]
   read -p "for some reason I need to have this here" yes
  done 
else
  echo "no file found there";
fi



# read -e -p "Enter file to cut: " fileToCut 

# read -p "Enter start time: " startTime

# read -p "Enter end time: " endTime

# startSeconds=$(date -u -d "$startTime" +"%s")
# endSeconds=$(date -u -d "$endTime" +"%s")

# length=$(date -u -d "0 $endSeconds sec - $startSeconds sec" +"%H:%M:%S")

# echo $length

# ffmpeg -i $fileToCut -ss $startTime -t $length -async 1 cut.mkv


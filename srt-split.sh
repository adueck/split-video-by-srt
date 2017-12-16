#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "Script to split video files into chunks based on .srt timecodes"
    echo ""
    echo "usage: srt-split.sh [video file] [subtitle file] (optional)[output format]"
    echo "If no output format is supplied, cut files will be saved in the same format as the original file."
    exit 0
fi

fileToCut=$1
subtitleFile=$2
format=$3

fileName=$(basename "$fileToCut")
fileExt="${fileName##*.}"
fileName="${fileName%.*}"

if [ ! -f "$fileToCut" ]
then
  echo "ERR: no file found at $fileToCut"
  echo "usage: srt-split.sh [video file] [subtitle file] (optional)[output format]"
  exit 1
fi

if [ -f "$subtitleFile" ]
then
  i=0
  echo "Extracting timecodes from subtitle file..."
  # create two arrays for the start times and durations of all the clips
  while read -r line ; do
   # extract start and end timecodes from each line of srt file
   startTime=`echo $line | egrep -o "^[0-9]{2}:[0-9]{2}:[0-9]{2},[0-9]{3}"`
   endTime=`echo $line | egrep -o " [0-9]{2}:[0-9]{2}:[0-9]{2},[0-9]{3}"`

   # format start time for Ffmpeg
   startTimeForFfmpeg[i]=`echo $startTime | sed 's/,/./'`

   # put timecode string in calculatable date format and then calculate the length of the clip
   startDate=$(date -u -d "$startTime" +"%s.%N")
   endDate=$(date -u -d "$endTime" +"%s.%N")
   timeDiff[i]=$(date -u -d "0 $endDate sec - $startDate sec" +"%H:%M:%S.%N")

   i=$[i+1]
  done < <(egrep "[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}" "$subtitleFile")
else
  echo "ERR: no file found at $subtitleFile"
  echo "usage: srt-split.sh [video file] [subtitle file] (optional)[output format]"
  exit 1
fi
echo "Ready to start cutting."
echo ""

# Make directory to store output clips
mkdir "$fileName-clips"

# loop through the arrays created earlier and cut each clip with ffmpeg
arrayLength=${#startTimeForFfmpeg[@]}
numOfClips=`expr $arrayLength`
exportErrorOccured=false
for k in `seq -w ${arrayLength}`
do
  j=`expr $k - 1`
  # if user specified a format, use that for the output, if not use original format
  if [ ! -z "$format" ]
  # assign the proper format to the output file to be passed to ffmpeg
  then
    echo -n "Cutting segment no. ${k} of ${numOfClips} and exporting to ${format}..."
    outputFile="$fileName-clips/${k}-$fileName.$format"
    else
    echo -n "Cutting segment no. ${k} of ${numOfClips} and exporting to original ${fileExt} format..."
    outputFile="$fileName-clips/${k}-$fileName.$fileExt"
  fi
  ffmpeg -v warning -i "$fileToCut" -ss "${startTimeForFfmpeg[j]}" -t "${timeDiff[j]}" "$outputFile"
  if [ $? -eq 0 ]; then
    echo OK
  else
    echo ERR
    exportErrorOccured=true
  fi
done

if [ "$exportErrorOccured" = false ]; then
  echo "Finished. Files are available in $PWD/$fileName-clips"
else
  echo "There were errors with the ffmpeg processing. Please see log above."
fi

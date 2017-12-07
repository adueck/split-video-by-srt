# split-video-by-srt

You can use this bash script to split a video file up into seperate chunks based on timecodes from an .srt subtitle file.

This could be especially useful for language learners looking to make an Anki deck out of phrases from a movie or TV show.

The script simply prompts you for a video file, then an .srt subtitle file. Then it takes the timecodes out of the .srt file and outputs a seperate video file for each subtitle duration.

**requires ffmpeg**

This works, but it is very beta. More features and safeguarding to come.

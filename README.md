# split-video-by-srt

You can use this bash script to automatically split video files up into seperate chunks based on timecodes from an .srt subtitle file.

This could be useful for:

- language learners looking to make an Anki deck out of phrases from a movie or TV show.
- people looking for an easier way to edit and export a large number of smaller clips from a larger file

I reccomend [Subtitle Edit](http://www.nikse.dk/SubtitleEdit/) for making subtitle files.

The script simply prompts you for a video/audio file, then an .srt subtitle file. Then it takes the timecodes out of the .srt file and outputs a seperate video/audio file for each subtitle duration.

**requires ffmpeg**

This works, but it is very beta. More features and functionality to come.

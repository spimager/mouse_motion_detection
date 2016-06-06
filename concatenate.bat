cd concatenate_source
(for %%i in (*.mp4) do @echo file '%%i') > mylist.txt
ffmpeg -f concat -i mylist.txt -c copy concatenated.mp4
cd ../
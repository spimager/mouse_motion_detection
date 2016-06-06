function vid_time_ch=compute_time(path,file)
    file_name=[path file];
    
    obj = VideoReader(file_name);                       % creating object for video file
    nframes = get(obj, 'NumberOfFrames');               % reading number of frame present in video file
    freq=obj.FrameRate;
    video_time=round(nframes/freq);

    vid_time_ch=compute_time_1(video_time);
    clear obj
end
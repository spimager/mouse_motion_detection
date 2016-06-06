function [vid_time_ch]=compute_time_1(video_time)
        vid_hrs=fix(video_time/3600);
        video_time=(video_time - round(vid_hrs*3600));

        vid_min=fix(video_time/60);
        video_time=(video_time - round(vid_min*60));

        if(video_time<0)
            video_time=0;
        end
        vid_sec=fix(video_time);
        if(vid_hrs<=9)
            vid_hrs_ch=['0' num2str(vid_hrs)];
        else
            vid_hrs_ch=num2str(vid_hrs);
        end

        if(vid_min<=9)
            vid_min_ch=['0' num2str(vid_min)];
        else
            vid_min_ch=num2str(vid_min);
        end

        if(vid_sec<=9)
            vid_sec_ch=['0' num2str(vid_sec)];
        else
            vid_sec_ch=num2str(vid_sec);
        end

        vid_time_ch=[vid_hrs_ch ':' vid_min_ch ':' vid_sec_ch];

end
function convert_videos(bitrate,selected_codec,scale_vids,path,file)
                tic;
                A = exist('converted_videos','dir');
                if(A==0)
                    mkdir('converted_videos')
                end
                
                A = exist('temp_data','dir');
                if(A==0)
                    mkdir('temp_data')
                end

                addpath('C:\FFMPEG\bin', '-end');
                
                global FFMPEG
                global FFPROBE
                
                if ismac
                    FFMPEG = 'ffmpeg-latest-win64-static/mac/ffmpeg';
                elseif isunix
                    FFMPEG = 'ffmpeg-latest-win64-static/mac/ffmpeg';
                elseif ispc
                    FFMPEG = 'ffmpeg-latest-win64-static\ffmpeg-20160512-git-cd244fa-win64-static\bin\ffmpeg.exe';
                    FFPROBE = 'ffmpeg-latest-win64-static\ffmpeg-20160512-git-cd244fa-win64-static\bin\ffprobe.exe';
                else
                    disp('Platform not supported')
                end
                
                file_name=[path file];
                
                h1 = waitbar(0,'Converting Videos');
                drawnow
                
                vid_name1=file_name;
                
                vid_name2=strcat('converted_',file(1:end-4),'.avi');
%                 ffmpeg_cmd = [FFMPEG ' -y -i ' vid_name1 ' -vcodec h264 -r 24 ' vid_name2];
                ffmpeg_cmd = [FFMPEG ' -y -i ' vid_name1 ' -r 24 ' vid_name2];
                system(ffmpeg_cmd);
                
                try
                    movefile('converted_*', 'converted_videos');
                catch
                end
                close(h1);
                toc;
end



    
    
    
    
    
    
    
    
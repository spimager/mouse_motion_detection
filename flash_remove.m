function flash_remove(path,file)

        h1 = waitbar(0,'File Processing');
        
        A = exist('temp_data','dir');
        if(A==0)
            mkdir('temp_data')
        end

        global FFMPEG
        FFMPEG = 'ffmpeg-latest-win64-static\ffmpeg-20160512-git-cd244fa-win64-static\bin\ffmpeg.exe';
        global FFPROBE
        FFPROBE = 'ffmpeg-latest-win64-static\ffmpeg-20160512-git-cd244fa-win64-static\bin\ffprobe.exe';
        
%         path = strcat(path,'flash_removed\');
        file_name=[path file];
        
        vid_name1=file_name;
        vid_name2=strcat('temp_data\',file(1:end-4),'_temp','.mp4');
        vid_name3=strcat(path,file(1:end-4),'_FlashRemoved','.mp4');
        
        system([ FFMPEG ' -y -i  ' vid_name1 ' -vcodec h264 ' vid_name2]);
        
        %//////////////////////////////////////////////////////
        
        
        obj = VideoReader(vid_name2);                      
        nframes = get(obj, 'NumberOfFrames');
        freq=obj.FrameRate;
        
        v = VideoWriter(vid_name3);
        open(v)
        
        %////////////////////////////////////////////////////
        
        
        flash_frames=[];
        k=1;
        while(k<nframes)  
                img_o=read(obj, k);  
                a=size(img_o);
                new_r=round(a(1)/3);
                new_c=round(a(2)/3);
                
                img_oo=img_o;
                img_o=imresize(img_o,[new_r new_c]);
                a=size(img_o);
                if(length(a)>2)                                     
                    img_o=rgb2gray(img_o);                          
                end

                col_1=img_o(:);
                col_m=mean(col_1(:));
                
              %  display(strcat('sec:',num2str(k/24),'int:',num2str(col_m)));

                if(col_m<5)
                    if(k-100<1)
                        min_f=1;
                    else
                        min_f=k-100;
                    end
                    
                    if(k+150>nframes)
                        max_f=nframes;
                    else
                        max_f=k+150;
                    end
                    flash_frames=[flash_frames;[min_f max_f]];
                    k=k+151;
                else
                    k=k+1;
                end
                
        end
       
        q=1;
        k=1;
        wait_count=0;
        while(q<nframes)
            img_o=read(obj, q);
            
            if(k<=size(flash_frames,1))
                if(q<flash_frames(k,1))
                    writeVideo(v,img_o)
                    q=q+1;
                else
                    for j=flash_frames(k,1):flash_frames(k,2)
                         writeVideo(v,img_o)
                    end
                    q=flash_frames(k,2)+1;
                    k=k+1;
                end
            else
                writeVideo(v,img_o)
                q=q+1;
            end
            
            if(wait_count>100)
                waitbar(q / nframes);
                drawnow;
                wait_count=0;
            end
            wait_count=wait_count+1;
            
        end
        close(v)
        close(h1); 
   
end
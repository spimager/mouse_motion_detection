function [motion,mov_mat,vid_time_ch]=extract_roi_with_compress(path,file)
                global sensitivity
                
                A = exist('temp_data','dir');
                if(A==0)
                    mkdir('temp_data')
                end

                global FFMPEG
                FFMPEG = 'ffmpeg-latest-win64-static\ffmpeg-20160512-git-cd244fa-win64-static\bin\ffmpeg.exe';
                global FFPROBE
                FFPROBE = 'ffmpeg-latest-win64-static\ffmpeg-20160512-git-cd244fa-win64-static\bin\ffprobe.exe';
                
                
                mov_mat{1,1}=[];
                motion=0;
                file_name=[path file];
                
                %////////////////////////////////////////////////////////////////
                
                h1 = waitbar(0,'File Processing');
                
                vid_name1=file_name;
                vid_name2 = vid_name1;
%                 vid_name2=strcat('temp_data\',file(1:end-4),'_c','.mp4');
%                 system([ FFMPEG ' -y -i  ' vid_name1 ' -vcodec h264 ' vid_name2]);
%                

                %////////////////////////////////////////////////////////////////
                
                  
                obj = VideoReader(vid_name2);                      
                nframes = get(obj, 'NumberOfFrames'); 
                freq=obj.FrameRate;
                
                video_time=round(nframes/freq);
                vid_time_ch=compute_time_1(video_time);

                img_b = read(obj, 1);                               
                a=size(img_b);
                new_r=round(a(1)/4);
                new_c=round(a(2)/4);
                
                img_b=imresize(img_b,[new_r new_c]);
                if(length(a)>2)                                     
                    img_b=rgb2gray(img_b);                         
                end
                img=double(img_b); 
                
                

                %////////////// calculating moving area /////////////////////

                display_status='of';
                th=20;  
                img_l=img; 
                

                last_mov_frame=0;
                mov_frames=0;
                non_mov_flag=0;
                m_flag=0;
                total_mov_time=0;

                qq=1;
                wait_count=0;
                dis_count=0;
                fig_flag=0;
                for k = 2 : nframes 
                                wait_count=wait_count + 1;
                                if(wait_count>100)
                                    waitbar(k / nframes);
                                    drawnow;
                                    wait_count=0;
                                end

                                img_o=read(obj, k);  
                                img_o=imresize(img_o,[new_r new_c]);
                                img_oo=img_o;
                                a=size(img_o);
                                if(length(a)>2)                                     
                                    img_o=rgb2gray(img_o);                          
                                end
                                d=abs(double(img_l) - double(img_o));           
                                d=d>th;                                        

                                d=bwareaopen(d,10);                             
                                d=imfill(d,'holes');

                                se=strel('disk',3);
                                d=imdilate(d,se);
                                
                                s=round((1-(sensitivity/100))*200);
                                d=bwareaopen(d,s);

                                [r,c]=find(d==1);
                                rec_flag=0;
                                if ~(isempty(r))
                                    [lab,num]=bwlabel(d);
                                    for i=1:num
                                        [r,c]=find(lab==i);
                                        pt_1(i,:)=[min(c) min(r)];
                                        len(i,1)=max(r)-min(r);
                                        br(i,1)=max(c)-min(c);
                                        rec_flag=1;
                                    end
                                    mov_frames=mov_frames + 1;
                                    non_mov_flag=0;

                                    if(mov_frames==1)
                                        last_mov_frame=k;
                                    end
                                    m_flag=1;
                                else
                                    if(m_flag==1)
                                        non_mov_flag=non_mov_flag + 1;
                                        if(non_mov_flag>200 || k==nframes)
                                            m_flag=0;
                                            final_mov_frame=k-(non_mov_flag);
                                            mov_frames=0;

                                            mov_time=final_mov_frame - last_mov_frame;
                                            video_time_1=round(last_mov_frame/freq);
                                            video_time_2=round(final_mov_frame/freq);
                                            video_time_3=round(mov_time/freq);

                                            total_mov_time=total_mov_time + video_time_3 + 1;


                                             vid_time_ch_1=compute_time_1(video_time_1);
                                             vid_time_ch_2=compute_time_1(video_time_2);
                                             vid_time_ch_3=compute_time_1(video_time_3);
                                             %display(strcat('from:',vid_time_ch_1,'to:',vid_time_ch_2,'duration:',vid_time_ch_3));

                                             mov_mat{qq,1}=last_mov_frame;
                                             mov_mat{qq,2}=final_mov_frame;
                                             mov_mat{qq,3}=vid_time_ch_1;
                                             mov_mat{qq,4}=vid_time_ch_2;
                                             mov_mat{qq,5}=vid_time_ch_3;

                                             qq=qq+1;

                                        end
                                    end
                                end



                            if(strcmp(display_status,'on'))
                                dis_count=dis_count+1;
                                    if(rec_flag==1 && dis_count>50)
                                        dis_count=0;
                                        figure(2)
                                        fig = get(groot,'CurrentFigure');
                                        subplot(1,2,1)
                                        imshow(img_oo);
                                        hold on
                                        for i=1:size(pt_1,1)
                                            rectangle('Position',[pt_1(i,:) br(i,1) len(i,1)],'EdgeColor','g');
                                        end
                                        hold off
                                        
                                        title(strcat('frame:',num2str(k)));
                                        subplot(1,2,2)
                                        imshow(d);
                                        title('ROI binary')
                                        drawnow
                                        
                                        fig_flag=1;
                                    end
                                    
                            end
                            img_l=img_o;
                            
                            if(rec_flag==1)
                                motion=1;
                            end

                            clear pt_1 len br
                end

                if(total_mov_time-1<=1)
                    motion=0;
                end
                
                total_mov_time=compute_time_1(total_mov_time-1);
                mov_mat{1,6}=total_mov_time;
                mov_mat{1,7}=nframes;
                mov_mat{1,8}=freq;
                
                if(fig_flag==1)
                    close(fig)
                end
                close(h1); 
                
end



    
    
    
    
    
    
    
    
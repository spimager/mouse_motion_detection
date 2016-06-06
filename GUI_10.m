function abc(arg)

clear all
close all
clc
                ffmpeg_load = msgbox('Looking for FFMPEG');
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
                
                try
                    system('ffmpeg');
                    system( FFMPEG );
                catch
                    close(ffmpeg_load);
                    ffmpeg_err = msgbox('FFMPEG is not installed on this computer. You must install it to proceed.','Error');
                    disp('FFMPEG is not installed on this computer. You must install it to proceed.');
                    close all
                end
                close(ffmpeg_load);
                


global path d process_data sel_obj current_freq selected_mov_mat play_flag sensitivity vid_border scale_vids selected_codec bitrate videoplayer
vid_border=0;                                                   % make 0 for removing the video border else 1

figure_1 = figure('MenuBar','none','Name','Mouse Motion Detection','NumberTitle','off','Position',[200,200,1000,600],'Resize','off');
                         
load_button =uicontrol('Style','Pushbutton','String','Open','Units', 'Normalized', 'Position',[.62 .94 .18 .05],...
 'FontSize',12,'HorizontalAlignment','Center','CallBack',@load_vids);

sel_button =uicontrol('Style','Pushbutton','String','Load Selected Timepoints','Units', 'Normalized', 'Position', [0.007 .45 .605 .05],...
 'FontSize',12,'HorizontalAlignment','Center','CallBack',@sel_vids);

process_selected_button =uicontrol('Style','Pushbutton','String','Process Selected','Units', 'Normalized', 'Position',[.81 .78 .18 .05],...
 'FontSize',12,'HorizontalAlignment','Center','CallBack',@progress_bar_sel);

process_all_button =uicontrol('Style','Pushbutton','String','Process All','Units', 'Normalized', 'Position',[.62 .78 .18 .05],...
 'FontSize',12,'HorizontalAlignment','Center','CallBack',@progress_bar_all);

convert_videos_button =uicontrol('Style','Pushbutton','String','Convert','Units', 'Normalized', 'Position',[.809 .58 .18 .05],...
 'FontSize',12,'HorizontalAlignment','Center','CallBack',@convert_large_vids);

concatenate_videos_button =uicontrol('Style','Pushbutton','String','Concatenate','Units', 'Normalized', 'Position',[.809 .52 .18 .05],...
 'FontSize',12,'HorizontalAlignment','Center','CallBack',@concatenate);

% scale_vids_checkbox =uicontrol('Style','Checkbox','String','Scale Videos','Units', 'Normalized', 'Position',[.63 .54 .16 .05],...
%  'FontSize',12,'HorizontalAlignment','Center','Value',1,'Callback',@scale_vids_check);

% bitrate_checkbox =uicontrol('Style','Checkbox','String','Scale Bitrate','Units', 'Normalized', 'Position',[.63 .50 .16 .05],...
%  'FontSize',12,'HorizontalAlignment','Center','Value',1,'Callback',@changeBitrate);

% codec_select_popupmenu = uicontrol('Style', 'popupmenu', 'FontName', 'FixedWidth', 'BackgroundColor', 'white', 'Units', 'Normalized', 'Position',[.62 .571 .16 .05], 'String', {'.avi','.mpg'}, 'Value' , 1, 'Callback', @changeCodecValue);
% set(codec_select_popupmenu,'Value',1);

%save_button =uicontrol('Style','Pushbutton','String','Export Results','Position',[10,40,110,22],...
% 'FontSize',12,'HorizontalAlignment','Center','CallBack',@save_csv);

exit_button =uicontrol('Style','Pushbutton','String','Exit','Units', 'Normalized', 'Position',[.008 .01 .18 .05],...
 'FontSize',12,'HorizontalAlignment','Center','CallBack',@exit_rot);

display_sen_text1 = uicontrol('Style','Text','String','60','Units', 'Normalized', 'Position',[.70 .875 .03 .03],'HorizontalAlignment','Left',...
      'ForegroundColor','Black','FontSize',12);
  
sld = uicontrol('Style', 'slider','Min',0,'Max',100,'Value',60,'Units', 'Normalized', 'Position',[.73 .875 .26 .03],'Callback', @sld_fun); 

clear_button =uicontrol('Style','Pushbutton','String','Clear List','Units', 'Normalized', 'Position',[.81 .94 .18 .05],...
 'FontSize',12,'HorizontalAlignment','Center','CallBack',@clear_fun);

rem_button =uicontrol('Style','Pushbutton','String','Remove Empties','Units', 'Normalized', 'Position',[.62 .7 .18 .05],...
 'FontSize',12,'HorizontalAlignment','Center','CallBack',@rem_fun);

flash_button =uicontrol('Style','Pushbutton','String','Remove Flash','Units', 'Normalized', 'Position',[.81 .7 .18 .05],...
 'FontSize',12,'HorizontalAlignment','Center','CallBack',@flash_fun);

display_sen_text = uicontrol('Style','Text','String','Sensitivity:','Units', 'Normalized', 'Position',[.62 .88 .078 .026],'HorizontalAlignment','Left',...
      'ForegroundColor','Black','FontSize',12);

% UI Columns

queue_columnname = {'','Filename','Motion','Video Length|(hh:mm:ss)'};
d={false 0 0 0};
tab = uitable('Units', 'Normalized', 'Position', [0.01 .505 .6 .48],'ColumnName', queue_columnname,...
    'Data',d,'ColumnWidth',{30,321,100,118},'ColumnEditable', [true false false false]);

timepoints_columnname = {'','Timepoint','Start|(hh:mm:ss)','End|(hh:mm:ss)', 'Duration|(hh:mm:ss)'};
d2={false 0 0 0 0};
tab2 = uitable('Units', 'Normalized', 'Position', [0.01 .06 .6 .38],'ColumnName', timepoints_columnname,...
    'Data',d2,'ColumnWidth',{30,134,135,135,135},'ColumnEditable', [true false false false false]);

% queue_columnname = {'','Filename','Motion','Video Length|(hh:mm:ss)','Detection Time|(hh:mm:ss)'};
% d={false 0 0 0 0};
% tab = uitable('Units', 'Normalized', 'Position', [0 .45 .6 .48],'ColumnName', queue_columnname,...
%     'Data',d,'ColumnWidth',{30,206,100,116,116},'ColumnEditable', [true false false false false]);

% UI Labels
% label_queueColumn = uicontrol('Style','Text','String','Videos','Position',[200,560,180,22],'HorizontalAlignment','Left',...
%       'ForegroundColor','Black','FontSize',14);
  
sld_vid = uicontrol('Style', 'slider','Min',1,'Max',100,'Value',1,'Units', 'Normalized', 'Position',[.62 .07 .31 .02],'Callback', @sld_vid_fun);

play_button =uicontrol('Style','Pushbutton','String','Play >','Units', 'Normalized', 'Position',[.91 .015 .082 .05],...
 'FontSize',12,'HorizontalAlignment','Center','CallBack',@play_vid);
stop_button =uicontrol('Style','Pushbutton','String','Stop','Units', 'Normalized', 'Position',[.828 .015 .082 .05],...
 'FontSize',12,'HorizontalAlignment','Center','CallBack',@stop_vid);
time_text = uicontrol('Style','Text','String','00:00:00','Units', 'Normalized', 'Position',[.94 .072 .07 .02],'HorizontalAlignment','Left',...
      'ForegroundColor','Black','FontSize',10);
  
  
axes('Units', 'Normalized', 'Position',[.62 .08 .37 .37])
bi(1:100,1:180,1:3)=0;
bi=uint8(bi);
if(vid_border==1)
    bi=frame_add(bi);
end
imshow(bi)
drawnow


%/////////////////// call back functions //////////////////////////////


    function load_vids(varargin)
        
        [files,path]=uigetfile('*.*','MultiSelect', 'on','select video files to load');
        addpath(genpath(path),'-end')
        addpath(genpath('temp_data'),'-end')
        if(iscell(files))
            for i=1:length(files)
                d{i,1}=false;
                d{i,2}=files{i};
                d{i,3}='Not Processed';
                d{i,4}='Not Processed';
                d{i,5}='Not Processed';
                
                set(tab,'Data',d);
                drawnow
            end
        else
                d{1,1}=false;
                d{1,2}=files;
                d{1,3}='Not Processed';
                d{1,4}='Not Processed';
                d{1,5}='Not Processed';
                
                set(tab,'Data',d);
                drawnow
        end
    end

    function scale_vids_check(varargin)
        scale_vids = get(scale_vids_checkbox, 'Value');
        scale_vids
    end

    function changeCodecValue(varargin)
        video_codec = get(codec_select_popupmenu, 'String');
        selected_codec = video_codec{get(codec_select_popupmenu,'Value')};
    end

    function changeBitrate(varargin)
        bitrate = get(bitrate_checkbox,'Value');
        if isempty(bitrate)
            bitrate = 1;
        end
        bitrate
    end

    function concatenate(varargin)
        t = datestr(now);
        t = strrep(t, ' ', '_');
        t = strrep(t, ':', '_');
        if ismac
            system('./concatenate.sh');
            system([FFMPEG ' -f concat -safe 0 -i  ./concatenate_source/mylist.txt -c copy ./concatenate_source/concatenated.mp4 -y ']);            
            concatFileName = strcat('concatenated_dest/concatenated.mp4');
            movefile('concatenate_source/concatenated.mp4', concatFileName);
            delete('concatenate_source/*.mp4')
            delete('concatenate_source/*.txt')
            uiwait(msgbox('Concatenation Complete','Success','modal'));
        elseif isunix
            system('./concatenate.sh');
            system([FFMPEG ' -f concat -safe 0 -i  ./concatenate_source/mylist.txt -c copy ./concatenate_source/concatenated.mp4 -y ']);            
        elseif ispc
            dos('concatenate.bat');
            concatFileName = strcat('concatenated_dest\concatenated.mp4');
            movefile('concatenate_source\concatenated.mp4', concatFileName);
            delete('concatenate_source\*.mp4')
            delete('concatenate_source\*.txt')
            uiwait(msgbox('Concatenation Complete','Success','modal'));
        else
            disp('Platform not supported')
        end

    end

    function convert_large_vids(varargin)
        if isempty(selected_codec)
            selected_codec = '.avi';
        end
        
        for step = 1:size(d,1)
            convert_videos(bitrate,selected_codec,scale_vids,path,d{step,2});
        end
        msgbox({'Conversion Complete';'Please reload videos'})
        d={false 0 0 0 0};
        set(tab,'Data',d);
        
        d2={false 0 0 0 0};
        set(tab2,'Data',d2);
        drawnow
    end

    function progress_bar_all(varargin)
        sensitivity=round(get(sld,'Value'));
        for step = 1:size(d,1)
            [motion,mov_mat,vid_time_ch]=extract_roi_with_compress_1(path,d{step,2});
           
            
            process_data{step,1}=mov_mat;
            process_data{step,2}=motion;
            d{step,4}=vid_time_ch;
            if(motion==2)
                d{step,3}='Flash Detected';
                d{step,5}='00:00:00';
            end
            if(motion==1)
                d{step,3}='Detected';
                d{step,5}=mov_mat{1,6};
            end
            if(motion==0)
                d{step,3}='Not Detected';
                d{step,5}='00:00:00';
            end

        end
        set(tab,'Data',d);
        drawnow
    end

    function progress_bar_sel(varargin)
        sensitivity=round(get(sld,'Value'));
        d1=get(tab,'Data');
        for step = 1:size(d,1)
           
            if(d1{step,1}==1)
                [motion,mov_mat,vid_time_ch]=extract_roi_with_compress_1(path,d{step,2});
                process_data{step,1}=mov_mat;
                process_data{step,2}=motion;
                d{step,4}=vid_time_ch;
                 if(motion==2)
                    d{step,3}='Flash Detected';
                    d{step,5}='00:00:00';
                end
                if(motion==1)
                    d{step,3}='Detected';
                    d{step,5}=mov_mat{1,6};
                end
                if(motion==0)
                    d{step,3}='Not Detected';
                    d{step,5}='00:00:00';
                end
            end
        end
        set(tab,'Data',d);
        drawnow
    end

    function sel_vids(varargin)
        sensitivity=round(get(sld,'Value'));
        d1=get(tab,'Data');
        a=cell2mat(d1(:,1));
        [r,c]=find(a==1);
        if(length(r)>1)
            h = warndlg('more than 1 files selected');
            pause(2)
            close(h)
        else
            
            d2={false 0 0 0 0};
            size(d)
            str=d{r,3};
            if(strcmp(str,'Detected'))
                a=d{r,2};
                a=a(1:end-4);
                try
                    file_name=['temp_data\' a '.avi'];
                    file_name
                    sel_obj = VideoReader(file_name); 
                catch
                    file_name=['temp_data/' a '.avi'];
                    file_name
                    sel_obj = VideoReader(file_name); 
                end
                img_b = read(sel_obj, 1);                               
                a=size(img_b);
                new_r=round(a(1)/4);
                new_c=round(a(2)/4);
                img_b=imresize(img_b,[new_r new_c]);
                if(vid_border==1)
                    img_b=frame_add(img_b);
                end
                imshow(img_b);
                drawnow
            
            %////////////////////////////////////////////////////
           
                mov_mat=process_data{r,1};
                motion=process_data{r,2};
                selected_mov_mat=mov_mat;
                if(motion==1)
                    for i=1:size(mov_mat,1)
                        d2{i,1}=false;
                        d2{i,2}=num2str(i);
                        d2{i,3}=mov_mat{i,3};
                        d2{i,4}=mov_mat{i,4};
                        d2{i,5}=mov_mat{i,5};
                    end
                     set(sld_vid,'Max',mov_mat{1,7});
                     current_freq=mov_mat{1,8};
                else
                    h = warndlg('No motion detected for selected video');
                    pause(2)
                    close(h)
                end
                set(tab2,'Data',d2);
                drawnow
            else
                h = warndlg('File not processed or no motion detected.');
                pause(2)
                close(h)
                
            end

        end
        
    end

    function sld_fun(varargin)
        a=round(get(sld,'Value'));
        set(sld,'Value',a);
        set(display_sen_text1,'String',num2str(a));
        drawnow
    end

    function clear_fun(varargin)
        d={false 0 0 0 0};
        set(tab,'Data',d);
        
        d2={false 0 0 0 0};
        set(tab2,'Data',d2);
        drawnow
    end

    function sld_vid_fun(varargin)
        fr=get(sld_vid,'Value');
        img_b = read(sel_obj, fr);                               
        a=size(img_b);
        new_r=round(a(1)/3);
        new_c=round(a(2)/3);
        imresize(img_b,[new_r new_c]);
        if(vid_border==1)
            img_b=frame_add(img_b);
        end
        imshow(img_b);
        drawnow
        
        video_time=round(fr/current_freq);
        vid_time_ch=compute_time_1(video_time);
        set(time_text,'String',vid_time_ch);
        drawnow
    end


    function play_vid(varargin)
        sensitivity=round(get(sld,'Value'));
        play_flag=1;
        d2=get(tab2,'Data');
        a=cell2mat(d2(:,1));
        [r,c]=find(a==1);
        if(isempty(r))
            h = warndlg('No time point selected.');
            pause(2)
            close(h)
        else
            if(length(r)==1)
                start_frame=selected_mov_mat{r,1};
                stop_frame=selected_mov_mat{r,2};
                for i=start_frame:2:stop_frame-1
                    img_o = read(sel_obj, i);  
                    img_l = read(sel_obj, i+1);
                    
%                     a=size(img_o);
%                     new_r=round(a(1)/4);
%                     new_c=round(a(2)/4);
%                     img_o=imresize(img_o,[new_r new_c]);
%                     img_l=imresize(img_l,[new_r new_c]);
                   
                    [pt_1,br,len,rec_flag]=extract_motion(img_o,img_l);
                    if(rec_flag==1)
                        if(vid_border==1)
                            img_o=frame_add(img_o);
                        end
                        videoplayer = figure(2);
                        imshow(img_o,'Border','tight')
                        hold on
                        for j=1:size(pt_1,1)
                            rectangle('Position',[pt_1(j,:) br(j,1) len(j,1)],'EdgeColor','g');
                            hold on
                        end
                        hold off
                    end
                    
                    video_time=round(i/current_freq);
                    vid_time_ch=compute_time_1(video_time);
                    set(time_text,'String',vid_time_ch);
                    set(sld_vid,'Value',i);
                    drawnow
                    
                    if(play_flag==0)
                        break
                    end
                end
            else
                h = warndlg('more than 1 time point selected');
                pause(2)
                close(h)
            end
        end
    end

	function stop_vid(varargin)
            play_flag=0;
            close(videoplayer);
    end

    function rem_fun(varargin)
        d_temp=get(tab,'Data');
        d_temp1={false 0 0 0 0};
        count=1;
        for i=1:size(d_temp,1)
            if ~(strcmp(d_temp(i,3),'Not Detected'))
                d_temp1(count,:)=d_temp(i,:);
                process_data(count,:)=process_data(i,:);
                count=count+1;
            end
        end
        d=d_temp1;
        set(tab,'Data',d);
    end

    function exit_rot(varargin)
        close all
    end



    function flash_fun(varargin)
        sensitivity=round(get(sld,'Value'));
        d1=get(tab,'Data');
        
        for i=1:size(d1,1)
            str=d1{i,3};
            if(strcmp(str,'Flash Detected'))
                a=d{i,2};
                flash_remove(path,a);
                d{i,3}='Flash Removed';
            end
        end
        set(tab,'Data',d);
    end

end



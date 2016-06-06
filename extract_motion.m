function [pt_1,br,len,rec_flag]=extract_motion(img_o,img_l)
global sensitivity
                    pt_1=[];
                    br=[];
                    len=[];
                    th=20;
                    a=size(img_o);
                    if(length(a)>2)                                     
                        img_o=rgb2gray(img_o);  
                        img_l=rgb2gray(img_l);
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
                    end
end
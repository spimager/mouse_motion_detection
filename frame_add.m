function bi_new=frame_add(bi)

[m,n,x]=size(bi);
bi_new(1:m+20,1:n+20,1)=38;
bi_new(1:m+20,1:n+20,2)=180;
bi_new(1:m+20,1:n+20,3)=255;
bi_new=uint8(bi_new);

bi_new(11:11+m-1,11:11+n-1,:)=bi;

end
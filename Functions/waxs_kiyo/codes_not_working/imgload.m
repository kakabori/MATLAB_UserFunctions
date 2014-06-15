
function tst2=imgload(imagefile)

fid=fopen(imagefile);
tst=fread(fid,1048576,'*uint16');%create a column vector with 1048576 elements
tst2=vec2mat(tst,1024);




%tst2(tst<=0)=1e-6;
%matimage=imrotate(tst2,-90);
%matimage=fliplr(matimage);
fclose(fid);
%imwrite(matimage,matimage2,'tif');
end
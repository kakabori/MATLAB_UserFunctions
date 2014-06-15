%function matimage=slurpNagle(imagefile)
%saved in C:\Documents and Settings\Thalia Mills\My
%Documents\Moa\New_Ideas folder

%imports .img file (from Rigaku rotating anode) according to the recipe 
%from STN's chemistry polymer collaborators.

%Rotates and flips the image also

function matimage=slurpNagle(imagefile)

fid=fopen(imagefile);
tst=fread(fid,3072,'uint8=>char');
tst2=fread(fid,[1024 1024],'uint16');
%tt2=find(tst2<=0);
%tst2(tt2)=1e-6;
matimage=imrotate(tst2,-90);
matimage=fliplr(matimage);
%matimage=tst2;
fclose(fid);
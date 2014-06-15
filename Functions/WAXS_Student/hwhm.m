%TTM 8/3/06  ; modified from peak_phi.m and sectplot.m 
% modified 11/15/06 to output qmax vs. phi matrix,d-spacing vs.phi
% matrix, hwhm vs. phi matrix, and corrlength vs. phi matrix
%1/16/07 ds (for chain correlating d-spcaing) was added

function [qmax,ds,hwhm,cl]=hwhm(imag,qrange,sectors,span)

nbin=length(sectors)-1;
qmax_list=[];
hwhm_list=[];
sectors_list=[];

if span==0
    for j=1:nbin            %integrate each sector and find qmax and qhalf
    a=integrate_sector(imag,[sectors(j) sectors(j+1)]);
    %Find peak max
    [qmax,Imax] = Find_Peak_for_hwhm(a,qrange);        
    
    %Find matrix entries corresponding to allowed q range: from qmin to qmax
    data=a;
    nlength=size(data,1);
    jmin=1;
    while (jmin<nlength)&(data(jmin,1)<qrange(1))
        jmin=jmin+1;
    end
    jmax=jmin;
    while (jmax<nlength)&(data(jmax,1)<qmax)
        jmax=jmax+1;
    end
    x=data([jmin:jmax],1);
    y=data([jmin:jmax],2);
    nelement=size(x,1);
    
    %Set phimin and Imin to first data point in range
    qmin=x(1);        
    Imin=y(1);
    %Calculate Ihalf and find phihalf; only takes region where data monotonic 
    Ihalf=0.5*(Imin+Imax);
    qhalf=interp1(y([1:nelement]),x([1:nelement]),Ihalf);
    hwhm=qmax-qhalf;
    qmax_list=[qmax_list,qmax];
    hwhm_list=[hwhm_list,hwhm];
    sectors_list=[sectors_list,sectors(j)];
    end
else
    for j=1:nbin            %integrate each and find qmax and qhalf
    a=integrate_sector(imag,[sectors(j) sectors(j+1)]);
    b=smooth_data(a,span);
    
    %Find peak max
    [qmax,Imax] = Find_Peak_for_hwhm(b,qrange);        
    
    %Find matrix entries corresponding to allowed q range
    data=b;
    nlength=size(data,1);
    jmin=1;
    while (jmin<nlength)&(data(jmin,1)<qrange(1))
        jmin=jmin+1;
    end
    jmax=jmin;
    while (jmax<nlength)&(data(jmax,1)<qmax)
        jmax=jmax+1;
    end
    x=data([jmin:jmax],1);
    y=data([jmin:jmax],2);
    nelement=size(x,1);
    %Set phimin and Imin to first data point in range
    qmin=x(1);        
    Imin=y(1);
    %Calculate Ihalf and find phihalf; only takes region where data monotonic 
    Ihalf=0.5*(Imin+Imax);
    qhalf=interp1(y([1:nelement]),x([1:nelement]),Ihalf);
    hwhm=qmax-qhalf;
    qmax_list=[qmax_list,qmax];
    hwhm_list=[hwhm_list,hwhm];
    sectors_list=[sectors_list,sectors(j)];
    end
end

figure;
plot(sectors_list,qmax_list,'k.');
xlabel('{\it\phi} (deg)');
ylabel('peak position (A^{-1})');

figure;                             %d added 1/16/07
ds_list=(2*pi)./qmax_list;
plot(sectors_list,ds_list,'k.');
xlabel('{\it\phi} (deg)');
ylabel('d (A)');

figure;
plot(sectors_list,hwhm_list,'k.');
xlabel('{\it\phi} (deg)');
ylabel('HWHM (A^{-1})');

figure;
corrlength_list=1./hwhm_list;
plot(sectors_list,corrlength_list,'k.');
xlabel('{\it\phi} (deg)');
ylabel('{\it\xi} (A)');;

qmax=[sectors_list',qmax_list'];                %added 11/15/06
ds=[sectors_list',ds_list'];                    %d added 1/16/07
hwhm=[sectors_list',hwhm_list'];
cl=[sectors_list',corrlength_list'];
end


    

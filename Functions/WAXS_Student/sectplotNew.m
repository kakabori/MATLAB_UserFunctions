%function sectplotNew(imag,sectors,span)
%Example [sect]=sectplotNew(dodp_45c,[5:10:75],20)
%  Integrates and plots 10 deg. sectors 5-15,15-25...65-75.  If span>0,
%  smooths data using the function smooth_data, with moving average and span.
%  If span=0, does not smooth data.
%  original secplot Made by GEST and TTM on 3/15/06
%  1/19/07 sectplotNew modified from sectplot so that it outputs a matrix with q as
%  the first column and the intensities for each sector as the next
%  columns.

function [sect]=sectplotNew(imag,sectors,span)

if (nargin<2)            %if only image specified, assigns sectors a value.
    sectors=[5:10:85];
end

if (nargin==2)
    span=0;
end

hold on;
colors='bgrcmykbgrcmykbgrcmyk';
nbin=length(sectors)-1;

if span==0
    a=integrate_sector(imag,[sectors(1) sectors(1+1)]);   % j=1 separately added so can have only one q column
    sect=a;                 
    plotter(a, colors(1));
    names(1)={sprintf('%d to %d',round(sectors(1)),round(sectors(1+1)))};
    for j=2:nbin            %integrate each sector and plot in turn.
    a=integrate_sector(imag,[sectors(j) sectors(j+1)]);    
    sect=[sect,a(:,2)];    %added 1/19/07
    plotter(a, colors(j));
    names(j)={sprintf('%d to %d',round(sectors(j)),round(sectors(j+1)))};
    end
else
    a=integrate_sector(imag,[sectors(1) sectors(1+1)]);
    b=smooth_data(a,span);
    sect=b;
    plotter(b, colors(1));
    names(1)={sprintf('%d to %d',round(sectors(1)),round(sectors(1+1)))};
    for j=2:nbin            %integrate each sector and plot in turn.
    a=integrate_sector(imag,[sectors(j) sectors(j+1)]);
    b=smooth_data(a,span);
    sect=[sect,b(:,2)]; 
    plotter(b, colors(j));
    names(j)={sprintf('%d to %d',round(sectors(j)),round(sectors(j+1)))};
    end
end

legend(names,'Fontsize',8,'Location','northeast');
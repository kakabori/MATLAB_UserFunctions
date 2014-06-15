%function result=smooth_data(data,span)
    %Uses Matlab's smooth routine with default "Moving Average" and number of points 
    %for smoothing specified by "span".
    %data is a two column matrix of the form [x,y].  Output is the smoothed
    %two-column matrix [x,y].

function result=smooth_data(data,span,xrange)

if (nargin<3)
    x=data(:,1);
    y=data(:,2);
else
    nlength=size(data,1);
    jmin=1;
    while (jmin<nlength)&(data(jmin,1)<xrange(1))
        jmin=jmin+1;
    end
    jmax=jmin;
    while (jmax<nlength)&(data(jmax,1)<xrange(2))
    jmax=jmax+1;
    end
    x=data([jmin:jmax],1);
    y=data([jmin:jmax],2);
end

y=smooth(y,span);
result=[x,y];
end
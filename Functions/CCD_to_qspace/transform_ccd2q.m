%result=transform_ccd2q(img,qr_range,qz_range,delta_q,omega,beamX,beamZ,Sdist,wavelength,pixelSize)
%
%Example:
%result = transform_ccd2q(ccd_img,[1.3 1.8],[0 0.8],0.0022,0.2,33,100,161.8,1.18,0.07113);
%
%This function transforms a CCD-space image into q-space image.
%The angle of incidence is negative if the beam enters the sample from
%the back of the substrate (transmission geometry). 
%In grazing incidence geometry, the angle of incidence is positive.
%After the interpolation, the program will set the value of an element to
%zero if the associated q-space is not accessible due to the way transmission
%experiment is set up or simply outside the detector. For the latter
%condition, 1024 by 1024 pixel-detector is assumed.
%
%Parameters
%==========
%img : input CCD image
%qr_range : qr_range(1) and qr_range(2) specify the minimum and maximum 
%           value of qr
%qz_range : qz_range(1) and qz_range(2) specify the minimum and maximum 
%           value of qz
%delta_q : specify the step size in q 
%omega : angle of incidence in degrees 
%beamX : horizontal beam position
%beamZ : vertical beam position
%Sdist : sample to detector distance
%wavelength : X-ray wavelength
%pixelSize : pixel size in mm per pixel

function result=transform_ccd2q(img, qr_range, qz_range, delta_q, ...
                                omega, beamX, beamZ, Sdist, wavelength, pixelSize)
%beamX = Y_cen;
%beamZ = 1024 - X_cen + 1;

Spec_to_Phos = Sdist / pixelSize;
X_Lambda = wavelength;
alpha_r=deg2rad(omega);

% Create the grid in qr-qz space. 
% qr-axis is along the horizontal axis in MATLAB 
% figure. qz-axis is along the vertical axis in MATLAB figure.
qr=qr_range(1):delta_q:qr_range(2);     
len_qr=length(qr);
qz=qz_range(1):delta_q:qz_range(2);  
len_qz=length(qz);
qr2=repmat(qr,[len_qz,1]);
qz2=repmat(qz',[1,len_qr]);

% Set up the transformation rules (equations) to go from CCD-space to
% Cartesian q-space.
q=sqrt(qz2.^2+qr2.^2);
sin_theta=X_Lambda*q/(4*pi);
A=find(sin_theta==0);%(qr, qz) = (0, 0) satisfies the condition.
sin_theta(A)=10^(-8);%to avoid MATLAB complaining about division by zero.
B=find(sin_theta==1);%This rarely happens for a typical range of qr and qz.
sin_theta(B)=1-10^(-8);

sin_phi=(X_Lambda*qz2/4/pi./sin_theta - sin_theta*sin(alpha_r)) ...
        ./sqrt(1-sin_theta.^2)/cos(alpha_r);
%these elements refer to points in q-space that are not accessible in experiment
indiceA=find(abs(sin_phi)>1); 
sin_phi(indiceA)=0;

cos_2theta = 1 - 2*sin_theta.^2;
C = find(cos_2theta==0);
cos_2theta(C) = 10^(-8);
tan_2theta = 2*sin_theta.*sqrt(1-sin_theta.^2)./cos_2theta;

X1 = beamX + Spec_to_Phos*tan_2theta.*sqrt(1-sin_phi.^2);
Y1 = beamZ + Spec_to_Phos*tan_2theta.*sin_phi;

%Interpolate at the points specified by the above rules.
Int=interp2(img,X1,Y1,'spline');

% Set elements to zero if their specified (qr, qz) points are not accessible
% or outside the CCD detector.
Int(indiceA)=0;%not accessible q-space
A = find(X1 > 1024);%A, B, C, and D are outside the detector
B = find(X1 < 1);
C = find(Y1 > 1024);
D = find(Y1 < 1);
Int(A) = 0;
Int(B) = 0;
Int(C) = 0;
Int(D) = 0;

% Convert floating data points to integer. Otherwise, the image is big, and
% plotting might become slow.
Int = int32(Int);

result = struct('qr',qr,'qz',qz,'Int',Int,'delta_qr',delta_q,'delta_qz',delta_q);

end

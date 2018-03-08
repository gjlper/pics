function smap_c = bias_c3d(I_0, smap)
% 3d bias correction on Smap

mth = .05*max(abs(I_0(:)));
mask = abs(abs(I_0) > mth);
D = log(abs((I_0))+eps);
Dmin = min(D(:));
Dmax = max(D(:));
Dn = (D-Dmin)/(Dmax-Dmin);
v = [0 0.34 0.72];
radius = floor(size(I_0,1)/20);
[compB,~]=BCFCM3D(single(Dn.*mask),v,struct('maxit',20,'epsilon',1e-7,'sigma',radius)); 
compB = exp(-compB*(Dmax-Dmin));
smap_c = min(compB(:))*smap./(repmat(compB,1,1,1,size(smap,4))+eps);
implay(compB/max(compB(:)));

    


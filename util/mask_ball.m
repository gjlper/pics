function mask = mask_ball(msize,rsize)
% ball shape mask
% input:
%   msize: matrix size
%   rsize: radius of ball
% output:
%   mask:  ball mask

ax = (1:msize(1))-floor((msize(1)+1)/2);
ay = (1:msize(2))-floor((msize(2)+1)/2);
az = (1:msize(3))-floor((msize(3)+1)/2);
[my,mx,mz] = meshgrid(ay,ax,az);
mask = (sqrt(mx.^2+my.^2+mz.^2)<=rsize);
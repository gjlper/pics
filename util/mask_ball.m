function mask = mask_ball(msize,rsize,s_flag)
% ball shape mask
% input:
%   msize: matrix size
%   rsize: radius of ball
%   s_flag: soft mask flag
% output:
%   mask:  ball mask

rsize = abs(rsize);
ax = (1:msize(1))-round((msize(1)+1)/2);
ay = (1:msize(2))-round((msize(2)+1)/2);
az = (1:msize(3))-round((msize(3)+1)/2);
    
[my,mx,mz] = meshgrid(ay,ax,az);

if ~isempty(s_flag)
    if s_flag
        % mask = exp(-sqrt(mx.^2+my.^2+mz.^2)/rsize);
        mask = rsize ./ ((mx.^2+my.^2+mz.^2) + rsize.^2 + eps);
    else
        mask = (sqrt(mx.^2+my.^2+mz.^2)<=rsize);
    end
else
    mask = (sqrt(mx.^2+my.^2+mz.^2)<=rsize);
end
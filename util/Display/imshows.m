function imshows(img_s, range, nc, nr)
% multi-frame image plot
% INPUTs:
%   img_s : image series
%   range : image intensity range
%   nc : number of columns
%   nr : number of rows
% 
%  Written by Xucheng Zhu

Img_s = squeeze(img_s);
Img_s = Img_s(:,:,:);
% matlab order
Img_s = flip(flip(permute(Img_s,[2 1 3]),1),2);
Isize_s = size(Img_s);

if nargin < 2
    range = zeros(1,2);
    range(1) = min(img_s(:));
    range(2) = max(img_s(:));
end

if nargin < 3
    nc = round(sqrt(Isize_s(3)));
end
nc = max(nc,[],1);

if nargin < 4
    nr = round(Isize_s(3)/nc);
end
nr = max(nr,[],1);

Isize_s(3) = min(Isize_s(3),[],nr*nc);
Img_s2 = zeros([Isize_s(1:2),nc*nr]);
Img_s2(:,:,1:Isize_s(3)) = Img_s;
Img_s2(:,:,Isize_s(3)+1:end) = range(1);
Img_s2 = permute(reshape(Img_s2,Isize_s(1),Isize_s(2),nr,nc),[1 4 2 3]);
Img_s2 = reshape(Img_s2,Isize_s(1)*nc,Isize_s(2)*nr);

figure;
imshow(Img_s2,range);
colorbar;
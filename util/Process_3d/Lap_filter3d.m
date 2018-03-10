function imgf = Lap_filter3d(img)
% 3D laplacian filter

fsize = size(img);
imgf = img(:,:,:,:);
msize = size(imgf);
[yy,xx,zz]=meshgrid(1:msize(2),1:msize(1),1:msize(3));
xx=round((xx-msize(1)/2-1))/msize(1);
yy=round((yy-msize(2)/2-1))/msize(2);
zz=round((zz-msize(3)/2-1))/msize(3);
k2=(xx).^2+(yy).^2+(zz).^2;
imgf = ifft3c(fft3c(imgf).*repmat(k2,1,1,1,msize(4)));
imgf = reshape(imgf,fsize);
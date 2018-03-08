function ksp = fft3c(img)
% fourier transform

msize = size(img);
img_t = img(:,:,:,:);
ksp = zeros(size(img_t));
for i = 1: size(img_t,4)
    ksp(:,:,:,i) = fftshift(fftn(ifftshift(img(:,:,:,i))));
end

ksp = reshape(ksp,msize);
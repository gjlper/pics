function Iconv = conv3d(I,filter)
% I image convolution via FFT

Isize = size(I);
I = I(:,:,:,:);
if (length(Isize)>3)
    filter = repmat(filter,1,1,1,size(I,4));
end

Iconv = ifft3c(fft3c(I).*fft3c(filter));

Iconv = reshape(Iconv,Isize);

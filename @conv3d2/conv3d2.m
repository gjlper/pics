function res = conv3d2(I_size,kernel_ft,padding_size,vec_flag)

% fourier domain convolution
% Inputs:
%   I_size: img size
%   kernel_ft: kernel freq domain (both even size, Real kernel matrix)
%   
if nargin < 3
    conv_size = I_size + size(kernel_ft);
else
    conv_size = I_size + padding_size;
end

if nargin < 4
    vec_flag = 1;
end


res.adjoint = 0;
res.I_size = I_size;
res.kernel_ft = fft3c(pad3d(ifft3c(kernel_ft),conv_size));
res.conv_size = conv_size;
res.vec_flag = vec_flag;
res = class(res,'conv3d2');



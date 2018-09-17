function res = conv3d2(I_size,kernel_ft,vec_flag)

% fourier domain convolution
% Inputs:
%   I_size: img size
%   kernel_ft: kernel freq domain (both even size)
%   
if nargin < 3
    padding_size = (size(kernel_ft)-I_size)/2;
end

if nargin < 4
    vec_flag = 1;
end

I_size = I_size+2*padding_size;
d_s = ceil(I_size/2 - padding_size);
d_e = ceil(I_size/2 + padding_size) + 1;

res.adjoint = 0;
res.I_size = I_size;
res.kernel_ft = kernel_ft;
res.padding_size = padding_size;
res.d_s = d_s;
res.d_e = d_e;
res.vec_flag = vec_flag;
res = class(res,'conv3d2');



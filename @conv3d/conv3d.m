function res = conv3d(I_size,kernel,padding_size,vec_flag)

% fourier domain convolution
% Inputs:
%  I_size: img size
%  
if nargin < 3
    padding_size = floor(size(kernel)/2);
end

if nargin < 4
    vec_flag = 1;
end

if numel(padding_size) > 3
    padding_size = padding_size(1:3);
elseif numel(padding_size) <3
    padding_size = [padding_size(1),...
        padding_size(1), padding_size(1)];
end

I_size = I_size+2*padding_size;
kernel_p = zeros(I_size);
k_size = size(a.kernel);
d_s = ceil(I_size/2 - k_size/2) + 1;
d_e = ceil(I_size/2 + k_size/2);

kernel_p(d_s(1):d_e(1), d_s(2):d_e(2), d_s(3):d_e(3)) ...
    = kernel;
d_s = ceil(I_size/2 - padding_size);
d_e = ceil(I_size/2 + padding_size) + 1;

res.adjoint = 0;
res.I_size = I_size;
res.kernel_ft = fft3c(kernel_p);
res.padding_size = padding_size;
res.d_s = d_s;
res.d_e = d_e;
res.vec_flag = vec_flag;
res = class(res,'conv3d');



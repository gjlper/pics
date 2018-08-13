function [smv_out, mask_out] = smv_lap(phase, mask, radius)
% laplacian based phase removal(phase unwrap + background removal)
phase_t = padarray(phase.*mask,[radius,radius,radius]);
mask_t = padarray(mask,[radius,radius,radius]);
psize = size(phase_t);

smv_kernel = zeros(psize);
s_k = ball3D(radius,[1,1,1]);
s_k = s_k./sum(s_k(:));
s_k(radius+1,radius+1,radius+1) = s_k(radius+1,radius+1,radius+1)-sum(s_k(:));
smv_kernel(psize(1)/2-radius+1:psize(1)/2+radius+1,...
    psize(2)/2-radius+1:psize(2)/2+radius+1,...
    psize(3)/2-radius+1:psize(3)/2+radius+1) = s_k;
smv_k = fft3c(smv_kernel);

phase_c = cos(phase_t).*mask_t;
phase_s = sin(phase_t).*mask_t;

smv_out = -(phase_c.*(ifft3c(smv_k.*fft3c(phase_s)))-...
    phase_s.*(ifft3c(smv_k.*fft3c(phase_c)))).*mask_t;
smv_out = real(smv_out(1+radius:psize(1)-radius,1+radius:psize(2)-radius...
    ,1+radius:psize(3)-radius));

% mask calculation
smv_kernel = zeros(psize);
s_k = ball3D(radius,[1,1,1]);
s_k = s_k./sum(s_k(:));
smv_kernel(psize(1)/2-radius+1:psize(1)/2+radius+1,...
    psize(2)/2-radius+1:psize(2)/2+radius+1,...
    psize(3)/2-radius+1:psize(3)/2+radius+1) = s_k;
smv_k = fft3c(smv_kernel);
mask_out = real(ifft3c(fft3c(double(mask_t)).*smv_k));
mask_out = (mask_out+1/(8*radius^3))>=max(mask_out(:));
mask_out = mask_out(1+radius:psize(1)-radius,1+radius:psize(2)-radius...
    ,1+radius:psize(3)-radius);
function res = mtimes(a,b)

s_b = reshape(b,a.I_size);
% padding
s_b = padarray(s_b,a.padding_size);

if a.adjoint
    % inverse
    s_bk = fft3c(s_b);
    s_bkf = s_bk .* a.kernel_ft;
    res = ifft3c(s_bkf);
    res = res(a.d_s(1):a.d_e(1),a.d_s(2):a.d_e(2),a.d_s(3):a.d_e(3));
else
    % forward
    s_bk = fft3c(s_b);
    s_bkf = s_bk .* a.kernel_ft;
    res = ifft3c(s_bkf);    
    res = res(a.d_s(1):a.d_e(1),a.d_s(2):a.d_e(2),a.d_s(3):a.d_e(3));
end
if a.vec_flag
    res = res(:);
end

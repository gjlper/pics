function res = mtimes(a,b)

s_b = reshape(b,a.I_size);
% padding
s_b = padarray(s_b,a.padding_size);

if a.adjoint
    % inverse
    s_bk = fft3c(s_b);
    s_bkf = s_bk .* a.kernel_ft;
    res = ifft3c(s_bkf);
else
    % forward
    s_bk = fft3c(s_b);
    s_bkf = s_bk .* a.kernel_ft;
    res = ifft3c(s_bkf);
end
if a.vec_flag
    res = res(:);
end

function res = mtimes(a,b)

s_b = reshape(b,a.I_size);
% padding
s_b = pad3d(s_b,a.conv_size);

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
res = crop3d(res,a.I_size);
if a.vec_flag
    res = res(:);
end

end




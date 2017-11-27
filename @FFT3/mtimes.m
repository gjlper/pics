function res = mtimes(a,b)

if a.adjoint
    % inverse
    s_b = ifftshift(b);
    for dim = 1:3
        s_b = ifft(s_b,[],dim);
    end
    res = fftshift(s_b);
else
    % inverse
    s_b = ifftshift(b);
    for dim = 1:3
        s_b = fft(s_b,[],dim);
    end
    res = fftshift(s_b);
end

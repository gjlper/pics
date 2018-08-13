function im = ifft2c(ksp)

im = fftshift(ifft2(ifftshift(ksp)));
function ksp = fft2c(im)

ksp = fftshift(fft2(ifftshift(im)));
function ksp = fft3c(im)

assert(ndims(im)==3,'Not 3D matrix');
ksp = fftshift(fftn(ifftshift(im)));
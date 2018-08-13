function im = ifft3c(ksp)

assert(ndims(ksp)==3,'Not 3D matrix');
im = fftshift(ifftn(ifftshift(ksp)));
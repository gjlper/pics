function res = FFT3()

% Multi3D FFT
% Inputs:
%  
%  Smap: kx, ky, kz, S, 1
%  Mask: kx, ky, kz, 1, M
res.adjoint = 0;
res = class(res,'FFT3');



function uphase = Lap_phase_unwrap3d(phase)
% isotropic phase image unwrapping
% input:
%   wrapped phase
% output:
%   unwrapped phase


msize=size(phase);
tphase = phase(:,:,:,:);
t = size(tphase,4);
[yy,xx,zz]=meshgrid(1:msize(2),1:msize(1),1:msize(3));
xx=round((xx-msize(1)/2-1))/msize(1);
yy=round((yy-msize(2)/2-1))/msize(2);
zz=round((zz-msize(3)/2-1))/msize(3);
k2=(xx).^2+(yy).^2+(zz).^2;
tk2 = repmat(k2,1,1,1,t);

Lphase = cos(tphase).*ifft3c(tk2.*fft3c(sin(tphase)))...
    - sin(tphase).*ifft3c(tk2.*fft3c(cos(tphase)));

uphasek = fft3c(Lphase)./(tk2+eps);
uphasek(floor(msize(1)/2+1),floor(msize(2)/2+1),floor(msize(3)/2+1),:) = 0;
uphase = real(ifft3c(uphasek));
% iterative update
Iter = 4;
uphase_j = phase;
for i = 1:Iter
    uphase_j = uphase_j + 2*pi*round((uphase - uphase_j)/(2*pi));
end
uphase = reshape(uphase,msize);


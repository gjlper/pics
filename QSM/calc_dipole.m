function kernel_dip = calc_dipole(Isize,H,type,ratio)
% modified dipole kernel for discrete operator, and noise amplification

if nargin<2
    H = [0,0,1];
end
if nargin<3
    type = 'continuous';
end
if nargin<4
    ratio = 1;
end


vx = ((1:Isize(1))-round((Isize(1)+1)/2))/size(Isize(1),1);
vy = ((1:Isize(2))-round((Isize(2)+1)/2))/size(Isize(2),1);
vz = ((1:Isize(3))-round((Isize(3)+1)/2))/size(Isize(3),1);

[ky,kx,kz] = meshgrid(vy,vx,vz);
if ~strcmp(type,'continuous')
    kx = cos(2*pi*kx) - 1;
    ky = cos(2*pi*ky) - 1;
    kz = cos(2*pi*kz) - 1;
end
dip1 = 1/3-(kx.^2*H(1)+ky.^2*H(2)+kz.^2*H(3))./(kx.^2+ky.^2+kz.^2+eps);
dip2 = 1/3-(kx.^2*H(1)+ky.^2*H(2)+kz.^2*H(3))./(kx.^2+ky.^2+kz.^2+eps);

kernel_dip = ratio*dip1+(1-ratio)*dip2;

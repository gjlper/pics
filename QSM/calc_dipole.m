function kernel_dip = calc_dipole(Isize,H,type,ratio)
% modified dipole kernel for discrete operator, and noise amplification

if nargin<2
    H = [0,0,1];
end
if nargin<3
    type = 'continuous';
end
if nargin<4
    ratio = 0;
end


vx = ((1:Isize(1))-round((Isize(1)+1)/2))/size(Isize(1),1);
vy = ((1:Isize(2))-round((Isize(2)+1)/2))/size(Isize(2),1);
vz = ((1:Isize(3))-round((Isize(3)+1)/2))/size(Isize(3),1);

[ky,kx,kz] = meshgrid(vy,vx,vz);
dip1 = 1/3-(kx.^2*H(1)+ky.^2*H(2)+kz.^2*H(3))./(kx.^2+ky.^2+kz.^2+eps);

if strcmp(type,'discrete')
    kx2 = 1 - cos(2*pi*kx);
    ky2 = 1 - cos(2*pi*ky);
    kz2 = 1 - cos(2*pi*kz);
    dip2 = 1/3-(kx2*H(1)+ky2*H(2)+kz2*H(3))./(kx2+ky2+kz2+eps);
else
    
    dip2 = dip1;
end


kernel_dip = ratio*dip1+(1-ratio)*dip2;
kernel_dip(round((Isize(1)+1)/2),round((Isize(2)+1)/2),round((Isize(3)+1)/2)) = 0;

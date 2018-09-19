function kernel_dip = calc_dipole(Isize,H,type,ratio, res)
% modified dipole kernel for discrete operator, and noise amplification
% Xucheng Zhu, July 2018

if nargin<2
    H = [0,0,1];
end
if nargin<3
    type = 'continuous';
end
if nargin<4
    ratio = 0;
end
if nargin<5
    res = [1,1,1];
end


vx = ((1:Isize(1))-round((Isize(1)+1)/2))/Isize(1);
vy = ((1:Isize(2))-round((Isize(2)+1)/2))/Isize(2);
vz = ((1:Isize(3))-round((Isize(3)+1)/2))/Isize(3);

[ky,kx,kz] = meshgrid(vy,vx,vz);
kx1 = kx/res(1);
ky1 = ky/res(2);
kz1 = kz/res(3);
kx2 = kx1.^2;
ky2 = ky1.^2;
kz2 = kz1.^2;
dip1 = 1/3-(kx1*H(1)+ky1*H(2)+kz1*H(3)).^2./(kx2+ky2+kz2+eps);

if strcmp(type,'discrete')
    kx1 = sin(pi*kx)/res(1);
    ky1 = sin(pi*ky)/res(2);
    kz1 = sin(pi*kz)/res(3);
    kx2 = kx1.^2;
    ky2 = ky1.^2;
    kz2 = kz1.^2;
    dip2 = 1/3-(kx1*H(1)+ky1*H(2)+kz1*H(3)).^2./(kx2+ky2+kz2+eps);
else
    
    dip2 = dip1;
end


kernel_dip = ratio*dip1+(1-ratio)*dip2;
%kernel_dip(round((Isize(1)+1)/2),round((Isize(2)+1)/2),round((Isize(3)+1)/2)) = 0;

function index1 =ball3D(r,voxelsize)
% ball matrix with input radius

[xx,yy,zz]=meshgrid(-r:r,-r:r,-r:r);

xx=xx*voxelsize(2);
yy=yy*voxelsize(1);
zz=zz*voxelsize(3);
v2=xx.^2+yy.^2+zz.^2;
index1=(v2<=(r.^2+r/3));



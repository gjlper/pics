function x_map = QSM_solver(Tissue_Phase, Tissue_Mask, TE, B0, lambda, niter, weight2, H, res, radius_dip)
% simple qsm solver with TGV constraint
% Input:
%   Tissue_Phase : phase after background removal [nx,ny,nz]
%   Tissue_Mask : soft tissue mask [nx,ny,nz]
%   TE : echo time (TODO: multi echo solver)
%   B0 : main field
%   weight2 : L2 norm weighting, (default 1)
%   H  : main field direction, (deault [0,0,1])
% Output:
%   x_map : qsm
%   
% Xucheng Zhu, August, 2018
Nin = 5;
if nargin < Nin+1
    niter = 20;
end
if nargin < Nin+2
    weight2 = 1;
end
if nargin < Nin+3
    H = [0,0,1];
end
if nargin < Nin+4
    res = [1,1,1];
end
if nargin < Nin+5
    radius_dip = 20;
end

% threshold for weighting, TODO R2* based weight
weight2 = weight2./max(weight2(:));
weight2 = max(weight2,.05);
weight2 = weight2.*Tissue_Mask;
weight =weight2.^2;

Isize = size(Tissue_Phase);
d_k = calc_dipole2(Isize,H,'discrete',0,res,radius_dip);
Conv_k = conv3d2(Isize,d_k,40);
gyro = 42;
constant = gyro*TE*B0;
rho = 1;
params.lambda = lambda/rho;% tuning 0.01
params.sigma = .25;% sigma * tau <= .5
params.tau = .25;
params.alpha0 = .05;
params.alpha1 = .01;
params.nflag = 1;
TGV_prox = TGV(params);

% calc (ATA+rhoI) inversion
A = @(x,flag)((Conv_k*(weight(:).*(Conv_k*x))) + rho*x); % TODO weighting
b0 = ((Conv_k*(weight2(:).*Tissue_Phase(:))));
delta_func = ifft3c(ones(Isize));
ATA_s = ones(Isize);
% ATA_s(:) = (Conv_k'*(weight2(:).*(Conv_k*delta_func)));
ATA_s(:) = (Conv_k'*(Conv_k*delta_func));
InvA_k = 1./(fft3c(ATA_s) + rho);
InvA = conv3d2(Isize,InvA_k,60);
x_k0 = zeros(Isize);
x_k0(:) = InvA*Tissue_Phase;
z_k0 = x_k0;
u_k0 = zeros(Isize);
x_k1 = x_k0;

for i = 1:niter
    % L2 optimization TODO: conjugate gradient descent
    cg_iterM = 15;
    b = (b0 + rho * (z_k0(:)-u_k0(:)));
    tol = 1e-10;
    x_k1(:)= lsqr(A,b,tol,cg_iterM,[],[],x_k0(:));    
    % cg update
    % x_k1(:) = cg_update2(A,b,x_k0(:),cg_iterM);
    % x_k1(:) = (InvA*b).*Tissue_Mask(:);
    tol_x = update_rate(x_k0,x_k1);
    fprintf('Relative residual: %f\n', tol_x); 
    % TV prox
    % weight
    z_k1 = TGV_prox*((x_k1+u_k0)).*Tissue_Mask;% edge problem
    
    u_k0 = u_k0 + (x_k1 -z_k1);
    x_k0 = x_k1;
    z_k0 = z_k1;
end

x_map = x_k0/constant.*Tissue_Mask;
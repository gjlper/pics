function x_map = QSM_solver(Tissue_Phase, Tissue_Mask, TE, B0, weight2, H)
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

if nargin < 5
    weight2 = 1;
end
if nargin < 6
    H = [0,0,1];
end
% threshold for weighting, TODO R2* based weight
weight2 = weight2./max(weight2(:));
weight2 = max(weight2,.05);
weight = 1./sqrt(weight2);

Isize = size(Tissue_Phase);
d_k = calc_dipole(Isize,H,'discrete');
gyro = 42;
constant = gyro*TE*B0;
rho = 1;
params.lambda = .01;% tuning
params.sigma = .25;% sigma * tau <= .5
params.tau = .25;
params.alpha0 = .05;
params.alpha1 = .01;
params.nflag = 0;
TGV_prox = TGV(params);
niter = 10;

FT = FFT3(Isize);% TODO simplify fft operator

A = @(x,flag)constant^2*(FT'*(d_k(:).*(FT*(weight2(:).*(FT'*(d_k(:).*(FT*x))))))) + rho*x; % TODO weighting
b0 = constant*(FT'*(d_k(:).*(FT*(weight2(:).*Tissue_Phase(:))))) ;


x_k0 = Tissue_Phase/constant;
z_k0 = zeros(Isize);
u_k0 = zeros(Isize);
x_k1 = x_k0;

for i = 1:niter
    % L2 optimization TODO: conjugate gradient descent
    cg_iterM = 15;
    b = (b0 + rho * (z_k0(:)-u_k0(:))) .* Tissue_Mask(:);
    tol = 1e-7;
    x_k1(:)= lsqr(A,b,tol,cg_iterM,[],[],x_k0(:));    
    % cg update
    % x_k1(:) = cg_update2(A,b,x_k0(:),cg_iterM);
    tol_x = update_rate(x_k0,x_k1);
    fprintf('Relative residual: %f\n', tol_x); 
    % TV prox
    % weight
    z_k1 = TGV_prox*(weight.*(x_k1+u_k0));% edge problem
    z_k1 = z_k1./weight;
    
    u_k0 = u_k0 + (x_k1 -z_k1);
    x_k0 = x_k1;
    z_k0 = z_k1;
end

x_map = x_k0;
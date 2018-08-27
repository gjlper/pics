function x_map = QSM_solver(Tissue_Phase, Tissue_mask, TE, B0, weight2, H)
% simple qsm solver with TGV constraint

if nargin < 5
    weight2 = 1;
end
if nargin < 6
    H = [0,0,1];
end


Isize = size(Tissue_Phase);
d_k = calc_dipole(Isize,H,'discrete');

constant = gyro*TE*B0;
rho = 1e-2;
params.lambda = .1;% tuning
params.sigma = .1;
params.tau = .1;
params.alpha0 = .1;
params.alpha1 = .1;
params.nflag = 1;
TGV_prox = TGV(params);
niter = 10;

FT = FFT3(Isize);% TODO simplify fft operator

A = @(x,flag)constant^2*(FT'*(d_k(:).*(FT*(weight2(:).*(FT'*(d_k(:).*(FT*x))))))) + rho*x; % TODO weighting

x_k0 = Tissue_Phase/constant;
z_k0 = zeros(Isize);
u_k0 = zeros(Isize);
x_k1 = x_k0;

for i = 1:niter
    % L2 optimization TODO: conjugate gradient descent
    cg_iterM = 8;
    b = (constant*(FT'*(d_k(:).*(FT*(weight2(:).*Tissue_Phase(:))))) + rho * (z_k0(:)-u_k0(:))) .* Tissue_mask(:);
    % x_k1(:)= lsqr(A,b,tol,cg_iterM,[],[],x_k0(:));    
    % cg update
    x_k1(:) = cg_update2(A,b,x_k0(:),cg_iterM);
    tol_x = update_rate(x_k0,x_k1);
    fprintf('Relative residual: %f\n', tol_x); 
    % TV prox
    z_k1 = TGV_prox*(x_k1+u_k0);% edge problem
    
    u_k0 = u_k0 + (x_k1 -z_k1);
    x_k0 = x_k1;
    z_k0 = z_k1;
end

x_map = x_k0;
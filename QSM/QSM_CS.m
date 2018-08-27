% function QSM = QSM_CS(Tissue_Phase, Mask, TE, Weight)
% QSM solver
% 

addpath(genpath('../../pics'));

I = squeeze(readcfl_s('../../Vo004r0e4_mr'));
Rt = I(:,:,:,4,2)./(I(:,:,:,1,2)+eps);
It = Rt.*abs(I(:,:,:,1,2)+eps);
It = TGV_denoise(It, 20, 5e-2);
TE = 600e-6;
H = [0,0,1];
B0 = 3;
gyro = 42.58;% 3T proton

phase = angle(It);
mag_sq = sqrt(abs(It)./max(abs(It(:))));
tmask = tissue_mask(I(:,:,:,1));
weight = tmask.*mag_sq;
weight2 = tmask.*mag_sq.^2;
Tissue_Phase = VSHARP(phase,tmask,12);

Isize = size(Tissue_Phase);

d_k = calc_dipole(Isize,H,'discrete');

%% inverse problem solver
% admm, 
% TODO scale the l2 term, magnitude weighing, TE correction
constant = gyro*TE*B0;
rho = 1e-3;
params.lambda = .1;% tuning
params.sigma = .1;
params.tau = .1;
params.alpha0 = .1;
params.alpha1 = .1;
params.nflag = 1;
TGV_prox = TGV(params);
niter = 5;

FT = FFT3(Isize);% TODO simplify fft operator

%% matlab lsqr solver

A = @(x,flag)constant^2*(FT'*(d_k(:).*(FT*(weight2(:).*(FT'*(d_k(:).*(FT*x))))))) + rho*x; % TODO weighting

x_k0 = Tissue_Phase/constant;
z_k0 = zeros(Isize);
u_k0 = zeros(Isize);
x_k1 = x_k0;

for i = 1:niter
    % L2 optimization TODO: conjugate gradient descent
    cg_iterM = 5;
    tol = 1e-7;
    b = (constant*(FT'*(d_k(:).*(FT*(weight2(:).*Tissue_Phase(:))))) + rho * (z_k0(:)-u_k0(:))) .* tmask(:);
    % x_k1(:)= lsqr(A,b,tol,cg_iterM,[],[],x_k0(:));    
    % cg update
    x_k1(:) = cg_update2(A,b,x_k0(:),cg_iterM);
    tol_x = relative_residual_l2(x_k0,x_k1);
    fprintf('Relative residual: %f\n', tol_x); 
    % TV prox
    z_k1 = TGV_prox*(x_k1+u_k0);% edge problem
    
    u_k0 = u_k0 + (x_k1 -z_k1);
    x_k0 = x_k1;
    z_k0 = z_k1;
end
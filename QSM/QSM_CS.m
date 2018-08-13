% function QSM = QSM_CS(Tissue_Phase, Mask, TE, Weight)
% QSM solver
% 

I = readcfl_s('../../UTE_denoise5');
phase = angle(I(:,:,:,1));
tmask = tissue_mask(I(:,:,:,1));
Tissue_Phase = VSHARP(phase,tmask);
TE = 100e-6;
gyro = 127;% 3T proton
Isize = size(Tissue_Phase);
H = [0,0,1];
d_k = calc_dipole(Isize,H,'discrete');

%% inverse problem solver
% admm, 
% TODO scale the l2 term, magnitude weighing, TE correction
constant = gyro*TE;
params.lambda = .1;% tuning
params.sigma = .1;
params.tau = .1;
params.alpha0 = .1;
params.alpha1 = .1;
params.nflag = 1;
TGV_prox = TGV(params);
niter = 20;
rho = 1e-3;
FT = FFT3(Isize);% TODO simplify fft operator
A = @(x,flag)constant*(tmask(:).*(FT'*(d_k(:).*(FT*x)))) + rho*x;

x_k0 = zeros(Isize);
z_k0 = zeros(Isize);
u_k0 = zeros(Isize);
x_k1 = x_k0;

for i = 1:niter
    % L2 optimization
    cg_iterM = 15;
    tol = 1e-6;
    b = (Tissue_Phase(:) + rho * (z_k0(:)-u_k0(:))) .* tmask(:);
    x_k1(:)= lsqr(A,b,tol,cg_iterM,[],[],x_k0(:));    
    
    % TV prox
    z_k1 = TGV_prox*x_k1;% edge problem
    
    u_k0 = u_k0 + (x_k1 -z_k1);
    x_k0 = x_k1;
    z_k0 = z_k1;
end
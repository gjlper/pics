function [I_out, v] = TGV_denoise(I_in, Iter, lambda)

% TGV denoising implementation 3D case
% input:
%   I_in: input image
%   Iter: iteration number
%   lambda: regularization param
% output:
%   I_out: output image
%   v: TGV

% u : optimized imaging
% v : Gradient
% p,q : dual variables

iter = 0;
I_in = I_in./max(abs(I_in(:))+eps);
u = I_in;
u_b = u;
v = pgradient(u,4);
v_b = v;
sigma = 0.05;
tau = 0.1;
alpha0 = 0.1;
alpha1 = 0.05;
p = zeros(size(u));
q = zeros(size(v));
while iter<Iter
    iter = iter+1;
    % dual update
    p = prox_linf2(p+sigma*(pgradient(u_b,4)-v_b),alpha0,4);
    q = prox_linf2(q+sigma*(pgradient(v_b,5)),alpha1,[4,5]);
    % primal update
    u_o = u;
    u = (lambda*(u + div4(p)) + tau*I_in)/(lambda+tau);
    u_b = u + (u - u_o);
    v_o = v;
    v = v + (p + div5(q));
    v_b = v + (v - v_o);
    
end

I_out = u_b;
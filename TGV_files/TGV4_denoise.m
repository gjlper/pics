function [I_out, v] = TGV4_denoise(I_in, Motion, corr, mask, Iter, lambda)

% TGV denoising implementation 4D case
% input:
%   I_in: input image
%   Motion:  motion matrix
%   corrmatrix: weighing the motion dimension
%   Iter: iteration number
%   lambda: regularization param
% output:
%   I_out: output image
%   v: TGV

% u : optimized imaging
% v : Gradient
% p,q : dual variables
% v_t : m_dimension
% p_t : dual variable

iter = 0;
I_in = I_in./max(abs(I_in(:))+eps);
u = I_in;
u_b = u;
v = pgradient(u,5);
v_b = v;
v_t = dgradient(u,4);


sigma = 0.05;
tau = 1;
alpha0 = 0.1;
alpha1 = 0.05;
alpha2 = 0.1;
p = zeros(size(u));
q = zeros(size(v));
p_t = zeros(size(v_t));
w_t = corr.*exp(-sqrt(squeeze(sum(Motion.^2,4)))/10).*mask;

while iter<Iter
    iter = iter+1;
    % dual update
    p = prox_linf2(p+sigma*(pgradient(u_b,5)-v_b),alpha0,5);
    q = prox_linf2(q+sigma*(pgradient(v_b,6)),alpha1,[5,6]);
    p_t = prox_linf(p_t+sigma*(w_t.*dgradient(u_b,4)),alpha2);
    
    % primal update
    u_o = u;
    u = (lambda*(u + div5(p) + w_t.*div(p_t,4)) + tau*I_in)/(lambda+tau);
    u_b = u + (u - u_o);
    v_o = v;
    v = v + (p + div6(q));
    v_b = v + (v - v_o);
    
end

I_out = u_b;
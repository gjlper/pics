function res = mtimes(a,b)
% TGV prox operator

if a.params.nflag
    b_n = b./max(abs(b)+eps);
    b_scale = max(abs(b)+eps);
else
    b_n = b;
    b_scale = 1;
end

u_b = b_n;
v = pgradient(b_n,4);
v_b = v;
sigma = 0.05;
tau = 0.1;
alpha0 = 0.1;
alpha1 = 0.05;
p = zeros(size(b_n));
q = zeros(size(v));
% interation??
Iter = 5;
for i = 1:Iter
    % dual update
    p = prox_linf2(p+sigma*(pgradient(u_b,4)-v_b),alpha0,4);
    q = prox_linf2(q+sigma*(pgradient(v_b,5)),alpha1,[4,5]);
    % primal update
    u_o = b_n;
    u = (lambda*(b_n + div4(p)) + tau*I_in)/(lambda+tau);
    u_b = u + (u - u_o);
    v_o = v;
    v = v + (p + div5(q));
    v_b = v + (v - v_o);
end

res = u_b * b_scale;


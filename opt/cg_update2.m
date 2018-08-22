function x_k1 = cg_update2(A, b, x0, Iter)

% add tol?
% initialize direction
g_k = (A(x0)) - b;
d_k = - g_k;
x_k = x0;
dQd_k = sum(vec(conj(d_k).*(A(d_k))))+eps;
Ad_kt = A(d_k);

iter = 0;
while iter <Iter
    iter = iter + 1;
    % gradient descent ? what if Q is not PSD?
    alpha_k = -sum(vec(conj(g_k).*d_k))/dQd_k;
    x_k = x_k + alpha_k * d_k;
    % update gradient and direction
    g_k = (A(x_k)) - b;
    beta_k = sum(vec(conj(g_k).*(Ad_kt)))/dQd_k;
    d_k = -g_k + beta_k*d_k;
    % for speed up
    Ad_kt = A(d_k);
    % calc dQd_k
    dQd_k = sum(vec(conj(d_k).*(Ad_kt)))+eps;
    
end

x_k1 = x_k ; 

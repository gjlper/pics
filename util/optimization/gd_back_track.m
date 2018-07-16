function x_n = gd_back_track(x, afunc, agrad, params)
% backtracking line search
% Input:
%   afunc:  cost function
%   agrad:  cost function gradient
%   params: c1, c2, alpha, beta, Iter, dir_flag
% Output:
%   x_n:    updated x

% parameter
c1 = params.c1; % scale for Armijo condition [0,1]
beta = params.beta; % stepsize scale scale [0,1]
alpha = params.alpha; % init stepsize 1
c2 = params.c2; % Wolfe condition
Iter = params.iter; % maximum iteration number

% direction calc
if isfield(params,'Hg')
    p = - Hg(x);% general gd
elseif isfield(params,'p')
    p = params.p;% deepest gd
else
    p = -agrad(x);
end

% normalization
p = p/norm(vec(p));

% backtracking prep
agrad_x = agrad(x);
t = -real(c1*sum(vec(conj(agrad_x).*p)));
fx0 = afunc(x);

% line search
iter = 0;
while iter < Iter
    alpha = alpha * beta;
    x_n = x + alpha * p;
    if real(sum(vec(conj(agrad(x_n)).*p))) < c2*real(sum(conj(agrad_x).*p))
        break;
    end
    if fx0 - afunc(x_n) >= t
        break;
    end
    iter = iter + 1;
end


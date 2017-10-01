function y = prox_linf(x,lambda)
% prox function for L1 norm
%   argmin_y 1/2*||y-x||^2_2 + lambda*||y||_inf
% input:
%   x       : input array
%   lambda  : regularization para

y = x./abs(x+eps).*min(lambda, abs(x));
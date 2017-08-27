function y = prox_l2(x,lambda)
% prox function for L1 norm
%   argmin_y 1/2*||y-x||^2_2 + lambda*||y||^2_2
% input:
%   x       : input array
%   lambda  : regularization para

size_x = size(x);
size_lambda = size(lambda);

if((size_lambda(1)==1)&&(length(size_lambda==1)==1))
    y = x/(2*lambda + 1);
else
    size_l = ones(1,length(size_x));
    size_l(1:length(size_lambda)) = size_lambda;
    lambda = repmat(lambda,size_x./size_l);
    y = x./(2*lambda + 1);
end
function y = prox_l2q(x,lambda)
% prox function for L1 norm
%   argmin_y 1/2*||y-x||^2_2 + lambda*||y||_2
% input:
%   x       : input array
%   lambda  : regularization para

size_x = size(x);
size_lambda = size(lambda);

if((size_lambda(1)==1)&&(length(size_lambda==1)==1))
    lambda = lambda*x./abs(x);
    y = wthresh(x,'s',lambda);
else
    size_l = ones(1,length(size_x));
    size_l(1:length(size_lambda)) = size_lambda;
    lambda = repmat(lambda,size_x./size_l);
    lambda = lambda.*x./abs(x);
    y = wthresh(x,'s',lambda);
end
    
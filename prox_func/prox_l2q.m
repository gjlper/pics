function y = prox_l2q(x,lambda)
% prox function for L2q norm
%   argmin_y 1/2*||y-x||^2_2 + lambda*||y||_2
% input:
%   x       : input array [N, n_vec,:]
%   lambda  : regularization para 1

% squeeze to 3d
size_x = size(x);
x = x(:,:,:);
n_vec = size(x,2);

lambda = lambda*x./(repmat(sqrt(sum(abs(x.^2),2)),1,n_vec,1)+eps);
y = wthresh(x,'s',lambda);
y = reshape(y,size_x);
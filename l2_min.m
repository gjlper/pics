function y = l2_min(A,b,x)
% solve l2-minimization
%   argmin_y ||Ay-b||^2_2

size_I = size(x);
b = b(:);
x = x(:);
y = lsqr(A,b,1e-6,20,[],[],x);
y = reshape(y,size_I);
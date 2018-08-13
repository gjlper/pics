function y = div(x,dim)
% single dim calculate divergence

y = x- circshift(x,1,dim);

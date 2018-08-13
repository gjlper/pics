function grad = pgradient(I, grad_dim)

grad = [];
for i = 1:3
    % tgrad = (circshift(I,1,i) - circshift(I,-1,i))/2;
    tgrad = I - circshift(I,-1,i);
    grad = cat(grad_dim,grad,tgrad);
end
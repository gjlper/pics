function grad = dgradient(I, d_dim)

grad = I - circshift(I,-1,d_dim);
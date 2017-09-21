function x_up = L2_CG(x,A,y,cg_iter,tol)
% input and output should be vectors

x_up = lsqr(A,y,tol,cg_iter,[],[],x(:));

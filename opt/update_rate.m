function rr = update_rate(x0,x1)
% return update_rate

rr = norm(vec(x0-x1))./(norm(vec(x0))+eps);
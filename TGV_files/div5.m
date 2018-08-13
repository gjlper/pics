function y = div5(x)
% calculate divergence

y = 0;
for i = 1:3
    % y = y + (circshift(x(:,:,:,:,i),1,i) - circshift(x(:,:,:,:,i),-1,i))/2;
    y = y + (x(:,:,:,:,i) - circshift(x(:,:,:,:,i),1,i));
end 


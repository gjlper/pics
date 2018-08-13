function w_ind = wavelet_index(S)
% calculate wavelet index

level = size(S,1)-1;
dim = size(S,2);
w_ind = zeros(level,1);

t = 2^dim-1;
w_ind(1) = prod(S(1,:));
for i = 2:level
    w_ind(i) = t*prod(S(i,:));
end
w_ind = cumsum(w_ind);
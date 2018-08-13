function im_c = sum_of_sqrt(im, dim)
% single dimension l2-norm

im_c = sqrt(sum(abs(im).^2,dim));
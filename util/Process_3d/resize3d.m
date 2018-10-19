function out = resize3d(in, osize)
% fft based resize

isize = size(in);
scale = 1/(prod(isize)./prod(osize));
assert((sum((isize>=osize))==3)||(sum((isize<=osize))==3),'Not support zoom in/out mix!');

if sum(isize>=osize)==3
    f_space = fft3c(in);
    f_space = crop3d(f_space,osize);
    out = ifft3c(f_space)*scale;
elseif sum(isize<=osize)==3
    f_space = fft3c(in);
    f_space = pad3d(f_space,osize);
    out = ifft3c(f_space)*scale;
else
    out = in;
end
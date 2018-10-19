function out = resize3d2(in, osize)
% fft based resize with apodization

if nargin<3
    fname = 'hamming';
end

isize = size(in);
scale = 1/(prod(isize)./prod(osize));
assert((sum((isize>=osize))==3)||(sum((isize<=osize))==3),'Not support zoom in/out mix!');

if sum(isize>=osize)==3
    f_space = fft3c(in);
    win = win3d(osize,fname);
    f_space = crop3d(f_space,osize);

    out = ifft3c(f_space.*win)*scale;
elseif sum(isize<=osize)==3
    f_space = fft3c(in);
    f_space = pad3d(f_space,osize);
    %win = win3d(osize,fname);
    %out = ifft3c(f_space.*win)*scale;
    out = ifft3c(f_space)*scale;
else
    out = in;
end
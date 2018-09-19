function out = crop3d( in, osize)
osize = max(osize,1);
isize = size(in);
assert(sum(isize>=osize)==3,'output size should smaller than input size');

pl = floor(isize/2) - floor(osize/2);
pr = ceil(isize/2) - ceil(osize/2);

out = in(pl(1)+1:end-pr(1),pl(2)+1:end-pr(2),pl(3)+1:end-pr(3));

end
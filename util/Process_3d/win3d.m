function win = win3d(osize,fname)

if nargin<2
    fname = 'bspline';
end

osize = max(floor(osize),1);
assert(numel(osize)==3,'Not 3D size input!');


win = win1d(osize(1),fname).*permute(win1d(osize(2),fname),[2 1])...
    .*permute(win1d(osize(3),fname),[3,2,1]);

end

function win = win1d(length,name)
% frequency domain 
if nargin<2
    name = 'bspline';
end
switch name
    case 'hanning'
        win = hanning(length);
    case 'hamming'
        win = hamming(length);
    case 'bspine'
        win = sinc(((0:(length-1))-ceil(length/2))/(length/2)).^4;
    otherwise
        win = hanning(length);
end


end
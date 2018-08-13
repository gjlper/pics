function wave = wave3d(arr3d, N, basename)
% complex wavelet 

if nargin<2
    N = 3;
end
if nargin<3
    basename = 'db4';
end

[C,S] = wavedec2(arr3d, N, basename);
w_ind = wavelet_index(S);
wave.C = C;
wave.S = S;
wave.ind = w_ind;
wave.basename = basename;
function wave = wave2d(arr2d, N, basename)
% complex wavelet 

if nargin<2
    N = 4;
end
if nargin<3
    basename = 'db4';
end

[C,S] = wavedec2(arr2d, N, basename);
w_ind = wavelet_index(S);
wave.C = C;
wave.S = S;
wave.ind = w_ind;
wave.basename = basename;
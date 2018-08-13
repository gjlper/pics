function arr3d = iwave2d(wave)
% inverse complex wavelet 

C = wave.C;
S = wave.S;
basename = wave.basename;

arr3d = waverec2(C, S, basename);

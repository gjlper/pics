function arr3d = iwave3d(wave)
% inverse complex wavelet 

C = wave.C;
S = wave.S;
basename = wave.basename;

arr3d = waverec3(C, S, basename);

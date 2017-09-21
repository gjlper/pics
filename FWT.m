function [Im_W, wt] = FWT(Im)
% wavelet transform:

Dim_M = length(size(Im));
wt = dwt3(Im,'db4');
Im_W = cat(Dim_M+1,wt.dec{1,1,1},wt.dec{2,1,1},wt.dec{1,2,1},...
    wt.dec{2,2,1},wt.dec{1,1,2},wt.dec{2,1,2},...
    wt.dec{1,2,2},wt.dec{2,2,2});
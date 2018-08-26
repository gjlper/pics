function [bias_field, Ic, noise_level] = bias_3d(I,radius,nbin)
% bias correction with fuzzy C means
% Ic = I * bias_field

nsample = numel(I);
mag = abs(I);
if nargin <2
    radius = max(min(round(min(size(I))/4),20),5);
end
if nargin <3
    nbin = round(nsample/5000);
    nbin = max(nbin,50);
end

% intensity histogram
[hist_mag, hist_mag_pos] = hist(mag(:),nbin);
plot(hist_mag_pos,hist_mag,'LineWidth',1);
mag_mean = mean(mag(:));
noise_level = input('Input noise level:');
noise_level = min(noise_level,mag_mean);

Dmin = log(noise_level);
Dmax = log(mag_mean);
mag_n = (log(mag+eps)-Dmin)/(Dmax-Dmin+eps);
v = [0 1 max(mag_n(:))];
% radius = 20;
[compB,~]=BCFCM3D(single(mag_n),v,struct('maxit',20,'epsilon',1e-6,'sigma',radius)); 
bias_field = exp(compB*(Dmax-Dmin));
bias_field = max(bias_field./mean(bias_field(:)),5e-2);
Ic = I./bias_field;

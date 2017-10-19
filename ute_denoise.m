% denoising testing
addpath ./pics

I = squeeze(readcfl('UTE_lres_pics'));
I = I./max(abs(I(:)));

I_f = zeros(size(I));

for i = 1:size(I,4)
    I_f(:,:,:,i) = TGV_denoise(I(:,:,:,i),20,0.02);
end

writecfl('UTE_denoise',I_f);


% denoising testing
addpath ../pics

I = squeeze(readcfl('../Vo002r0e3_sg'));
I = I./max(abs(I(:)));

I_f = zeros(size(I));

for i = 1:size(I,4)
    I_f(:,:,:,i) = TGV_denoise(I(:,:,:,i),20,0.05);
end

writecfl('../Vo002r0e3_sgf',I_f);


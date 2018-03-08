function localizer2(filename,k_flag)
if(k_flag)
    ksp = readcfl(filename);
    I0 = fftshift(ifft(ifft(ifft(ifftshift(ksp),[],1),[],2),[],3));
else
    I0 = readcfl(filename);
end
I = sqrt(sum(abs(I0.^2),4));

figure;
subplot(2,2,1);
imagesc(squeeze(I(:,:,floor(size(I,3)/2))));
subplot(2,2,2);
imagesc(squeeze(I(:,floor(size(I,2)/2),:)));
subplot(2,2,3);
imagesc(squeeze(I(floor(size(I,1)/2),:,:)));


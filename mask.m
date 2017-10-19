addpath BCFCM_version_1/
QSM = readcfl('QSM_denoise');
I = abs(squeeze(readcfl('UTE_denoise')));
I = I./max(I(:));
Isize = size(I(:,:,:,1));
N = size(I,4);

%%

th=.08;
l_mask = zeros(size(I));
b_mask = zeros(size(I));
pmask = zeros(Isize);
for f = 1:N
    for i = 1:size(I,3)
        pmask(:,:,i) = imfill(I(:,:,i)>th,'holes');
    end
    pmask(:,:,[1:25,175:198]) = 0;
    b_mask(:,:,:,f) = pmask;
    l_mask(:,:,:,f) = bwareaopen(pmask.*(pmask-(I(:,:,:,f)>th)),40*40*40,6);
end

QSM = QSM.*l_mask;
% bias correction
% denoise
% mask
%% registration
Mfield = zeros([Isize,3,N]);
MI =I;
QSM_r = QSM;
for i = 2:N
    [Motion, Img] = imregdemons(I(:,:,:,i),I(:,:,:,1));
    Mfield(:,:,:,:,i) = Motion;
    MI(:,:,:,i) = Img;
    QSM_r(:,:,:,i) = imwarp(QSM(:,:,:,i),Motion);
end

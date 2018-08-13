function mask = tissue_mask(I,bias_flag)
% mask out tissue 

if nargin<2
    bias_flag = 1;
end

I_1 = abs(I)/max(abs(I(:))+eps);
Isize = size(I_1);
% bias correction
if bias_flag
    [~,I_c,~] = bias_3d(I_1,1000);
else
    I_c = I_1;
end

% mask
th=.04;
mask = zeros(Isize);
for i = 1:size(I,3)
    mask(:,:,i) = imfill(I_c(:,:,i)>th,'holes');
end

mask = bwareaopen(mask,round(numel(I_1)/20));

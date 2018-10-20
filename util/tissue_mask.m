function mask = tissue_mask(I,bias_flag,slab_ratio)
% mask out tissue 

if nargin<2
    bias_flag = 1;
end

if nargin < 3
    slab_ratio = 0;
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
slab_ind = ceil(min(1-abs(slab_ratio),[],1)*size(I,3)/2);
for i = 1+slab_ind:size(I,3)-slab_ind
    mask(:,:,i) = imfill(I_c(:,:,i)>th,'holes');
end

mask = bwareaopen(mask,round(numel(I_1)/20));

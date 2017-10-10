function [Kmotion, Kmean, Kstd, Kmaxr, Kstdr] = mfilt_reg(I_ref, I_mov, K_size, R_size, stride)
% rough 3D motion estimation based on matching filter
% Input: 
%   I_ref: reference img 
%   I_mov: moving img
%   K_size: moving img block size 1x3
%   R_size: ref img block size 1x3
%   stride: iterval between kernels 1x3
% Output:
%   Kmotion: motion matrix
%   Kmean: block mean 
%   Kstd: block std
%   Kmeanr: corr mean
%   Kmaxr: corr max
%   Kstdr: corr std

Isize = size(I_ref);
i_array = (1+R_size(1)/2):stride(1):(Isize(1)-R_size(1)/2);
j_array = (1+R_size(2)/2):stride(2):(Isize(2)-R_size(2)/2);
k_array = (1+R_size(3)/2):stride(3):(Isize(3)-R_size(3)/2);

I_ref = I_ref/prod(R_size);
I_mov = I_mov/prod(K_size);
KI = ones(K_size);

pi = 0;
pj = 0;
pk = 0;
Ksize = [length(i_array),length(j_array),length(k_array)];
Kstd = zeros(Ksize);
Kmean = zeros(Ksize);
Kmeanr = zeros(Ksize);
Kmotion = zeros([Ksize,3]);
Kstdr = zeros(Ksize);
Kmaxr = zeros(Ksize);


for i = i_array
    pi = pi + 1;
    pj = 0;
    for j = j_array
        pj = pj + 1;
        pk = 0;
        for k = k_array
            pk = pk + 1;
            Kmov = I_mov(i-K_size(1)/2+1:i+K_size(1)/2,...
                j-K_size(2)/2+1:j+K_size(2)/2,...
                k-K_size(3)/2+1:k+K_size(3)/2);
            Kmov = flip(flip(flip(Kmov,1),2),3);
            Kref = I_ref(i-R_size(1)/2+1:i+R_size(1)/2,...
                j-R_size(2)/2+1:j+R_size(2)/2,...
                k-R_size(3)/2+1:k+R_size(3)/2);
            Kcov = convn(Kref,Kmov,'valid');
            Kcovr = sqrt(convn(Kref.^2,KI,'valid'));
            Kcor = Kcov./(Kcovr);

            [tx, ty, tz] = ind2sub(size(Kcor),find(Kcor(:)==max(Kcor(:)),1));
            Kmeanr(pi,pj,pk) = mean(Kcor(:));
            Kstdr(pi,pj,pk) = std(Kcor(:));
            Kmotion(pi,pj,pk,:) = [tx ty tz];
            Kmaxr(pi,pj,pk) = max(Kcor(:));
            
            Kmean(pi,pj,pk) = mean(Kmov(:));
            Kstd(pi,pj,pk) = std(Kmov(:));
            
        end
    end
end

% centralize Kmax
for i = 1:3
    Kmotion(:,:,:,i) = Kmotion(:,:,:,i)-floor((R_size(i)-K_size(i))/2+1);
end
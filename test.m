% test
I = squeeze(readcfl('/Users/zhuxucheng/Documents/Research/Motion/trash1'));
N = size(I,4);
Isize = size(I(:,:,:,1));
K_size = [10,10,10];
R_size = [30,30,30];
stride = [10,10,10];

i_array = (1+R_size(1)/2):stride(1):(Isize(1)-R_size(1)/2);
j_array = (1+R_size(2)/2):stride(2):(Isize(2)-R_size(2)/2);
k_array = (1+R_size(3)/2):stride(3):(Isize(3)-R_size(3)/2);
[mgridx,mgridy,mgridz] = meshgrid(j_array,i_array,k_array);
[Mgridx,Mgridy,Mgridz]  = meshgrid(1:Isize(2),1:Isize(1),1:Isize(3));
%%
Kmotions = [];
Kmeans = [];
Kstds = [];
Kmaxrs = [];
Km = zeros([Isize,3]);
%%
for i = 1:N
    p = mod(i,N)+1;
    [Kmotion, Kmean, Kstd, Kmaxr, ~] = mfilt_reg(I(:,:,:,i),I(:,:,:,p),...
        K_size,R_size,stride);
    Kmeans = cat(4,Kmeans,Kmean);
    mask = Kmean>mean(Kmean(:))*.5;%% how to auto??
    
    % interpolation
    for j = 1:3
        motion = Kmotion(:,:,:,j).*mask;
        Km(:,:,:,j) = interp3(mgridx,mgridy,mgridz,motion,Mgridx,Mgridy,Mgridz,'linear');    
    end
    Kmotions = cat(5,Kmotions,Km);
    Kstds = cat(4,Kstds,Kstd);
    Kmaxr = interp3(mgridx,mgridy,mgridz,Kmaxr.*mask,Mgridx,Mgridy,Mgridz,'linear'); %?? correct
    Kmaxrs = cat(4,Kmaxrs,Kmaxr);
    
end
Kmotions(isnan(Kmotions))=0;
Kmaxrs(isnan(Kmaxrs))=0;
%%
Iter = 30;
lambda = 0.01;
[I_out, v] = TGV4_denoise(I, Kmotions, Kmaxrs, Kmaxrs>0, Iter, lambda);
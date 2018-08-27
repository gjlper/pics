% dyn_QSM
addpath(genpath('../../pics'));
% load multi-echo data
I = squeeze(readcfl_s('../../Vo004r0e4_mr'));
I = I./max(abs(I(:)));
Isize = size(I);
nstate = Isize(4);
necho = Isize(5);
% extrapolation TODO

% Mask
tmask = tissue_mask(sum(I(:,:,:,:),4),0);
% phase 
dTE = .25;
TE = dTE * (necho-1);
phase = angle(I(:,:,:,:,end)./(I(:,:,:,:,1)+eps)).*tmask;

[~, Tissue_Mask, bkg_phase] = VSHARP(phase,tmask,12);
Tissue_Phase = angle(I(:,:,:,:,end)./exp(1i*bkg_phase));

% Motion resolved processing
% QSM inversion
dQSM = zeros(Isize(1:4));
for i = 1:nstate
    dQSM(:,:,:,i) = QSM_solver(Tissue_Phase(:,:,:,i), Tissue_mask, TE, 3);
end

% registration
% deform_field = zeros([Isize(1:3),3,nstate]); % do not save deform field
Is = zeros([Isize(1:3),nstate]);
sQSM = zeros(Isize(1:4));
ref = 3;
Is(:,:,:,ref) = abs(I(:,:,:,ref)); 
sQSM(:,:,:,ref) = dQSM(:,:,:,ref);
for i = 1:nstate
    if i~=ref
        [D,Is(:,:,:,i)] = imregdemons(abs(I(:,:,:,i)),abs(I(:,:,:,ref)));
        sQSM(:,:,:,i) = imwarp(dQSM(:,:,:,i),D);
    end
end

    

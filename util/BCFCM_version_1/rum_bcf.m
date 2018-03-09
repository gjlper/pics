% This function BCFCM3D, segments (clusters) an imagevolume in object classes,
% and estimates the bias field.
%
% It's an implementation of the paper of M.N. Ahmed et. al. "A Modified Fuzzy 
% C-Means Algorithm for Bias Field estimation and Segmentation of MRI Data"
% 20002, IEEE Transactions on medical imaging.
%
% [B,U]=BCFCM3D(Y,v,Options)
%
% Inputs,
%   Y : The 3D greyscale input image of data-type Single
%   v : Class prototypes. A vector with approximations of the greyscale
%       means of all image classes. It is also possible to set values
%       further away from the mean to allow better class separation.
%   Options : A struct with options
%   Options.epsilon : The function stops if difference between class means
%                   of two itterations is smaller than epsilon
%   Options.alpha : Scales the effect of neighbours, must be large if 
%                   it is a noisy image, default 1.
%   Options.maxit : Maximum number of function itterations
%   Options.sigma : Sigma of Gaussian smoothing of the bias field (slow
%                   varying non uniform illumination in CT or MRI scan).
%   Options.p : Norm constant FCM objective function, must be larger than one
%               defaults to 2.
% Outputs,
%   B : The estimated bias field
%   U : Fuzzy Partition matrix (Class membership)
%
% Example, 
%
% % Compile the c-code
%   mex BCFCM3D.c -v
% % Load test volume
addpath /home/pcao/matlab/BCFCM_version_1
%   load MRI;
% Convert to single
%dd = 1;
Ndiv = 33;
im1_bcf = zeros(size(im1));
Ball = zeros(size(im1));
scale = zeros(1,Ndiv);
for dd = 1:Ndiv
    disp(sprintf('Ndiv %d',dd));
    im = squeeze(im1(:,:,:,dd));
    scale(dd) = max(abs(im(:)))/2;
    D = (abs(im/scale(dd)))*88;
    D = single(D)/88;
    % Class prototypes (means)
    v = [0 0.34 0.72 0.75 1.4];
    % Do the fuzzy clustering
    [B,U]=BCFCM3D(D,v,struct('maxit',20,'epsilon',1e-7,'sigma',8));
    
    im1_bcf(:,:,:,dd) = (abs(im) - scale(dd)*B).*exp(i*angle(im));
    Ball(:,:,:,dd) = B;
    % Show results
    %%
    figure,
    a = 60;
    subplot(2,2,1), imshow(D(:,:,a)), title('A slice of input volume');
    subplot(2,2,2), imshow(squeeze(U(:,:,a,2:4))), title('3 classes of the partition matrix');
    subplot(2,2,3), imshow(B(:,:,a),[]), title('Estimated biasfield');
    subplot(2,2,4), imshow(D(:,:,a)-B(:,:,a)), title('Corrected slice');
    %
    % Function is written by D.Kroon University of Twente (November 2009)
end

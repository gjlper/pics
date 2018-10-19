function writevideo(fname, img3d, N, N_start, framerate)
% export 3d image as video
% Xucheng Zhu, Sept 2018

img3d = img3d(:,:,:);
img3d = img3d./max(abs(img3d(:)));

if nargin<3
    N = size(img3d,3);
end
if nargin<4
    N_start = 0;
end
N_start = min(N_start,N);
if nargin<5
    framerate = 5;
end

fname = [fname,'.mp4'];
v = VideoWriter(fname,'MPEG-4');
v.FrameRate = framerate;
figure;
imshow(img3d(:,:,1))
open(v);
for k = N_start:N-1 
   imshow(img3d(:,:,mod(k,size(img3d,3))+1))
   axis tight manual 
   frame = getframe(gcf);
   writeVideo(v,frame);
end
close(v);
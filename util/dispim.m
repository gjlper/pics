% dispim(im,low,high)
% displays magnitude version of image im (complex array)
%
%
%	This was taken from the "standard" dispim.m used
%	in MRSRL.  No changes have been made, though it
%	would be nice to have some default scaling...
%

% =============== CVS Log Messages ==========================
%	This file is maintained in CVS version control.
%
%	$Log: dispim.m,v $
%	Revision 1.1  2006-10-19 19:47:25  peder
%	from brian
%
%	Revision 1.3  2004/04/13 01:36:20  brian
%	minor edits
%	
%	Revision 1.2  2003/05/29 23:05:44  brian
%	minor edits
%	
%	Revision 1.1  2002/04/02 21:35:40  bah
%	Initial in CVS.
%	
%
% ===========================================================


function dispim(im,low,high)

im = squeeze(im);

% display image
scale= 256/(high-low);
offset = scale*low;

% set colormap for 256 gray levels
c = colormap;
if (sum(abs(std(c')))>0.01)	% Only change colormap if it is not gray.
	a=[1 1 1]/256;
	b=[1:256];
	c=(a'*b)';
	colormap(c);
end;

image(abs(im)*scale-offset);
axis('square');



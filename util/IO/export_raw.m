function export_raw(name,I, comment)
% write image matrix into bin file
% assume real single input
% *.dat: binary data
% *.hdr: header, with dim and comments
% Xucheng Zhu, Sept. 2018

fname = [name,'.dat'];
fid = fopen(fname,'w');
I_u = single(I-min(I(:)));
fwrite(fid,I_u,'single');
fclose(fid);

Isize = size(I);
hname = [name,'.hdr'];
fid = fopen(hname,'w');
fprintf(fid,'%d ',Isize);
fprintf(fid,'\n');
if nargin >= 3
    fprintf(fid,[comment,'\n']);
end
fclose(fid);
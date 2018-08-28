function h5_export(filename,data,dir_name)
% simple h5 export function
if nargin < 3
    dir_name = '/data';
end
if ~endsWith(filename,'.h5')
    filename = [filename,'.h5'];
end
h5write(filename,dir_name,data);
fprintf('Data is written in %s under %s.\n',filename, dir_name);
end


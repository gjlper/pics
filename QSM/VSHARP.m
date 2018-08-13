function [t_phase, t_mask, bkg_phase] = VSHARP(rawphase,tmask,level)
% multi-level background phase removal
% xucheng zhu
if nargin <3
    level = 5;
end

t_phase = zeros(size(rawphase));
t_mask  = zeros(size(rawphase));
for i = 1:level
    radius = i;
    [tmp_phase, tmp_mask] = smv_lap(rawphase,tmask,radius);
    t_phase(tmp_mask) = tmp_phase(tmp_mask);
    t_mask = t_mask+tmp_mask;
end

% without unwrapping (TODO)
bkg_phase = rawphase-t_phase;
t_mask = t_mask>0;
    
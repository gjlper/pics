function [t_phase, t_mask, bkg_phase] = VSHARP(rawphase,tmask,level)
% multi-level background phase removal with phase unwrapping
% Input:
%   rawphase : raw phase after coil combination
%   tmask : tissue mask
%   level : V SHARP level (default 8) TODO: physical unit
% Output:
%   t_phase : tissue phase
%   t_mask : tissue mask after background phase removal
%   bkg_phase : background phase
%
% Xucheng Zhu, June 2018
if nargin <3
    level = 8;
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
    
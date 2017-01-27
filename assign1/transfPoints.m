function [Hstart, Hend] = transfPoints(H, startpoints, endpoints)
%TRANSFPOINTS Summary of this function goes here
%   Detailed explanation goes here

n = length(startpoints);

ett = ones(1, n);

Hstart = H*[startpoints; ett];
Hstart = pflat(Hstart);

Hend = H*[endpoints; ett];
Hend = pflat(Hend);


end


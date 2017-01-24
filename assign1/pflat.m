function x = pflat(X)
%PFLAT Summary of this function goes here
%   Detailed explanation goes here

denominator = X(end, :);

[m,n] = size(X);


denominator = repmat(denominator, [m,1]);
x = X./denominator;


end


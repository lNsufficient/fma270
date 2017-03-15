function x = pflat(X)
%PFLAT This function needs no explaination
%   No explanation goes here

denominator = X(end, :);

[m,n] = size(X);


denominator = repmat(denominator, [m,1]);
x = X./denominator;


end


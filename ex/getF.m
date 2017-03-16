function Fn = getF(x1, x2)
%GETF Calculates fundamental matrix using svd and 8-point algorithm.
%DONT CALL F = getF(x1,x2), THIS METHOD IS CALLED BY OTHER METHODS (svd S
%is not 0 in last).

M = getMF(x1,x2);
[~, ~, V] = svd(M);

v = V(:,end);

Fn = reshape(v, [3 3]);

end


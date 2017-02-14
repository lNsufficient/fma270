function Fn = getF(x1, x2)
%GETF Calculates fundamental matrix using svd and 8-point algorithm.

M = getMF(x1,x2);
[~, ~, V] = svd(M);

v = V(:,end);

Fn = reshape(v, [3 3]);

end


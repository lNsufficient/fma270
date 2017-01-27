function [R, Q] = rq(A)
%RQ factorization of square matrix A.

[q, r] = qr((flipud(A))');
R = flipud(fliplr(r'));
Q = flipud(q');

end


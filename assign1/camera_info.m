function [t, prin, K, Rt] = camera_info(P)
%CAMERA_INFO Summary of this function goes here
%   Detailed explanation goes here

A = P(:,1:3);
[K, R] = rq(A);
lambda = K(end, end);
K = K/lambda;
Rt = K\P;
test = sqrt(sum(sum((Rt(:,1:3) - R).^2)));
tol = 1e-5;
if test > tol
    disp('following should be zero. Is not!')
    Rt(:,1:3) - R
end
t = Rt(:,end);
[~, ~, V] = svd(Rt);
prin = V(:,end);

end


function [t, prin, K, Rt] = camera_info(P)
%CAMERA_INFO Summary of this function goes here
%   Detailed explanation goes here

A = P(:,1:3);
[R, K] = qr(A);
Rt = K\P;
disp('following should be zero. Is not!')
Rt(:,1:3) - R
t = Rt(:,end);
[~, ~, V] = svd(Rt);
prin = V(:,end);

end


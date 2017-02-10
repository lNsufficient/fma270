function [f, xp, gamma, skew, k] = getCamParams(P)
%GETCAM returns f, xp, gamma, skew
A = P(:,1:3);
k = rq(A);
k = k./k(3,3);
f = k(2,2);
xp = k(1:2,end);
gamma = k(1,1)/f;
skew = k(1,2)/f;

end


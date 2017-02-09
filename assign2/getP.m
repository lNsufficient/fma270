function P = getP(p, N)
%GETP Simply returns p assuming it is 3x4

P= zeros(3,4);
P(1,:) = p(1:4)';
P(2,:) = p(5:8)';
P(3,:) = p(9:12)';
P = N\P;

end


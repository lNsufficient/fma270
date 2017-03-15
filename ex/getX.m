function X = getX(P1, P2, x1, x2)
%GETXI Calculates the X coordinates given P1, P2, x1, x2 (matching points)


N = size(x1,2);
X = zeros(4, N);

for i = 1:N
    MXi = getMX(P1, P2, x1(:,i), x2(:,i));
    [~,~,V] = svd(MXi);
    Xi = V(1:4,end);
    X(:,i) = pflat(Xi);
end
end


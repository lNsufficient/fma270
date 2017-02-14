function X = getX_normalized(P1, P2, N1, N2, x1, x2)
%GETX_NORMALIZED Uses N1, N2 to find X by first normalizing, then
%transforming back.

X = getX(N1*P1, N2*P2, N1*x1, N2*x2);

end


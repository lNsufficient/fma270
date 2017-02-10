function M = getMX(P1, P2, x1, x2)
%GETMX returns the M matrix that can be used to find X
x1 = [x1;1];
x2 = [x2;1];
zer = zeros(3,1);
M = [P1, -x1, zer; P2, zer, -x2];


end


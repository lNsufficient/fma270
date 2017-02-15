function cexc4()
%CEXC4 Computer Excercise 4
format short;
load 'cexc3Data.mat';

x1_tilde = K\x1;
x2_tilde = K\x2;


exc6 = 1;
if exc6
    U = [1 -1 0; 1 1 0; 0 0 0]/sqrt(2);
    U(end, end) = 1;
    V = [1 0 0; 0 0 -1; 0 1 0];
else
    [U, ~, V] = svd(E_tilde);
end

W = [0, -1, 0; 1 0 0; 0 0 1];

E = U*W*V';

plot(diag(x2_tilde'*E_tilde*x1_tilde));

P2 = p_exc6(U, W, V);
P1 = [eye(3) zeros(3,1)];

X_all = cell(4,1);
P = cell(2,1);
P{1} = P1;
for i = 1:4
    X = getX(P1, P2{i}, x1, x2);
    P{2} = P2{i};
    X_all{i} = X;
    
    figure(1+i)
    clf;
    plot3(X(1,:), X(2,:), X(3,:), '.');
    hold on;
    plotcams(P);
end


end


function cexc4()
%CEXC4 Computer Excercise 4
format short;
load 'cexc3Data.mat';

x1_tilde = K\x1;
x2_tilde = K\x2;


%exc6 = 0;
% if exc6
%     U = [1 -1 0; 1 1 0; 0 0 0]/sqrt(2);
%     U(end, end) = 1;
%    V = [1 0 0; 0 0 -1; 0 1 0];
%else
[U, S, V] = svd(E_tilde);
%end

W = [0, -1, 0; 1 0 0; 0 0 1];

E = U*W*V';

plot(diag(x2_tilde'*E_tilde*x1_tilde));

P2 = p_exc6(U, W, V);
P1 = [eye(3) zeros(3,1)];

X_all = cell(4,1);
P = cell(2,1);
P{1} = P1;
for i = 1:4
    X = getX(P1, P2{i}, x1_tilde, x2_tilde);
    P{2} = P2{i};
    X_all{i} = X;
    
    figure(1+i)
    clf;
    plot3(X(1,:), X(2,:), X(3,:), '.');
    hold on;
    plotcams(P);
    
    
    px2 = P2{i}*X;
    totPoints = length(px2);
    gp2 = sum(px2(end,:) > 0)/totPoints;
    
    px1 = P1*X;
    gp1 = sum(px1(end,:) > 0)/totPoints;
    
    if (gp2>0.5) && (gp1 > 0.5)
        disp(sprintf('good points, kamera %d', i))
    else
        disp('bad points')
    end
end

i =4;
P1_k = K*P1;
P2_k = K*P2{i};

x2p = pflat(P2_k*X_all{i});
i2 = imread('assignment3data/kronan2.JPG');
figure(6);
clf
imagesc(i2);
hold on
plot(x2(1,:), x2(2,:), 'b.', 'MarkerSize', 12);
plot(x2p(1,:), x2p(2,:), '.r');

end


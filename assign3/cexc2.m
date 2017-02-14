function cexc2()
%CEXC2 Computer Excercise 2.
load exc1Data



P1 = [eye(3) zeros(3,1)];

[~, ~, V] = svd(F');
e2 = V(:,end);
P2 = [cross_mat(e2)*F e2];

x1_tilde = N1*x1;
x2_tilde = N2*x2;

X = getX_normalized(P1, P2, N1, N2, x1, x2); 
X = pflat(X);

figure(1)
clf;
I1 = imread('assignment3data\kronan1.JPG');
imagesc(I1);
hold on
x1p = P1*X;
x1p = pflat(x1p);
plot(x1p(1,:), x1p(2,:), 'r.')

figure(2)
clf;
I2 = imread('assignment3data\kronan2.JPG');
imagesc(I2);
hold on;
x2p = P2*X;
x2p = pflat(x2p)
plot(x2p(1,:), x2p(2,:), 'r.')


figure(3)
clf;
plot3(X(1,:), X(2,:), X(3,:), 'r.')

end


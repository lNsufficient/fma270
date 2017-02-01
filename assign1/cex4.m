clear;

I1 = imread('assignment1data/compEx4im1.JPG');
I2 = imread('assignment1data/compEx4im2.JPG');

load 'assignment1data/compEx4.mat';

figure(1)
imagesc(I1)
colormap 'gray';

figure(2)
imagesc(I2)
colormap 'gray';

[t1, prin1] = camera_info(P1);
[t2, prin2] = camera_info(P2);

s = 10;
Uplot = pflat(U);

figure(3)
plot3(Uplot(1,:), Uplot(2,:), Uplot(3,:), '.')
hold on;
%prin1 = prin2;
quiver3(t1(1), t1(2), t1(3), prin1(1), prin1(2), prin1(3), s, 'r'); 

plot3(t1(1), t1(2), t1(3), '.')
plot3(t1(1), t1(2), t1(3), 'ro')


quiver3(t2(1), t2(2), t2(3), prin2(1), prin2(2), prin2(3), s, 'r'); 
plot3(t2(1), t2(2), t2(3), '.')
plot3(t2(1), t2(2), t2(3), 'ro')


P1u = pflat(P1*U);
P2u = pflat(P2*U);

figure(4);
plot(P1u(1,:), P1u(2,:), '.')

figure(5);
plot(P2u(1,:), P2u(2,:), '.')
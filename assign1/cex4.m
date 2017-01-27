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

prin2 = pflat(prin2);

Uplot = pflat(U);

figure(3)
plot3(Uplot(1,:), Uplot(2,:), Uplot(3,:), '.')
hold on;
prin1 = prin2;
quiver3(t1(1), t1(2), t1(3), prin1(1), prin1(2), prin1(3)); 

plot3(t1(1), t1(2), t1(3), '.')

quiver3(t2(1), t2(2), t2(3), prin2(1), prin2(2), prin2(3)); 
plot3(t2(1), t2(2), t2(3), '.')


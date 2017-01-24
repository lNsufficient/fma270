clear;
load 'assignment1data/compEx1.mat'


x2 = pflat(x2D);

figure(1)
plot(x2(1,:), x2(2,:), '.')
axis equal

x3 = pflat(x3D);
figure(2)
plot3(x3(1,:), x3(2,:), x3(3,:), '.');
axis equal
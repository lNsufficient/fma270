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

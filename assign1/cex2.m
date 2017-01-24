clear all;

addpath('assignment1data/')
I = imread('assignment1data/compEx2.JPG');


load 'assignment1data/compEx2.mat';

points = [p1 p2 p3];



imagesc(I)
colormap 'gray'
hold on;
plot(points(1,:), points(2,:), 'or')

rital(p1, '-r');


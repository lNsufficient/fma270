clear all;

addpath('assignment1data/')
I = imread('assignment1data/compEx2.JPG');


load 'assignment1data/compEx2.mat';

points = [p1 p2 p3];



imagesc(I)
colormap 'gray'
hold on;
plot(points(1,:), points(2,:), 'or')

l1 = pflat(null(p1'));
l2 = pflat(null(p2'));
l3 = pflat(null(p3'));


rital([l2 l3], '-g');
rital(l1, '-r');


p23 = pflat(null([l2'; l3']));

d = l1'*p23/sqrt(sum(l1(1:2).^2));

plot(p23(1), p23(2), 'og');

str = sprintf('Distance to point from red line: %1.4f', d);
title(str)
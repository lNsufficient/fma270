clear;
run('~/vlfeat-0.9.20/toolbox/vl_setup')
addpath 'assignment2data'
load compEx3data.mat

im1 = imread('cube1.JPG');
im2 = imread('cube2.JPG');

[f1, d1] = vl_sift(single(rgb2gray(im1)), 'PeakThresh', 1);
[f2, d2] = vl_sift(single(rgb2gray(im2)), 'PeakThresh', 1);

figure(1)
imagesc(im1)
hold on;
vl_plotframe(f1);

[matches, scores] = vl_ubcmatch(d1, d2);

x1 = [f1(1,matches(1,:)); f1(2,matches(1,:))];
x2 = [f2(1,matches(2,:)); f2(2,matches(2,:))];

perm = randperm(size(matches ,2));
figure(2);
imagesc ([im1 im2]);
hold on;
plot([x1(1,perm (1:10));  x2(1,perm (1:10))+ size(im1 ,2)], ...
[x1(2,perm (1:10));  x2(2,perm (1:10))] ,'-');
hold  off;

load 'camMatrices'
P1 = P{1};
P2 = P{2};
normalize = 1;
if normalize
    [~, ~, ~, ~, k1] = getCamParams(P1);
    [~, ~, ~, ~, k2] = getCamParams(P2);
    P1 = k1\P1;
    P2 = k2\P2;
    x1 = (k1\[x1; ones(1,length(x1))]);
    x1 = x1(1:2,:);
    x2 = k2\[x2; ones(1,length(x2))];
    x2 = x2(1:2,:);
end

X = getX(P1, P2, x1, x2);

if normalize
    P1 = k1*P1;
    P2 = k2*P2;
    x1 = k1*[x1; ones(1,length(x1))];
    x1 = x1(1:2,:);
    x2 = k2*[x2; ones(1,length(x2))];
    x2 = x2(1:2,:);
end

figure(3);
plot3(X(1,:), X(2,:), X(3,:),'.')
title('ser inget på denna pga outliers')
%% Plot x1 med P1(X)

x1p = pflat(P1*X);
figure(4)
imagesc(im1)
hold on;
plot(x1(1,:), x1(2,:), '.b' ,'MarkerSize', 12)
plot(x1p(1,:), x1p(2,:), '.r')
if normalize
    title('Plot utan att ta bort dåliga punkter, kamera 1, normalized')
else
    title('Plot utan att ta bort dåliga punkter, kamera 1')
end
%% Ta bort dåliga punkter

xproj1 = pflat(P1*X);
xproj2 = pflat(P2*X);
good_points = (sqrt(sum((x1-xproj1 (1:2 ,:)).^2))  < 3 &   ...
                sqrt(sum((x2-xproj2 (1:2 ,:)).^2))  < 3);
            
X = X(:, good_points );

x1_good = x1(:,good_points);
x2_good = x2(:,good_points);

xproj1 = pflat(P1*X);
xproj2 = pflat(P2*X);

%% Plottar igen
figure(5)
imagesc(im1)
hold on;
plot(x1_good(1,:), x1_good(2,:), '.b' ,'MarkerSize', 12)
plot(xproj1(1,:), xproj1(2,:), '.r')
if normalize
    title('Plot då endast good\_points visas, kamera 1, normalized')
else
    title('Plot då endast good\_points visas, kamera 1')
end

figure(6)
imagesc(im2)
hold on;
plot(x2_good(1,:), x2_good(2,:), '.b' ,'MarkerSize', 12)
plot(xproj2(1,:), xproj2(2,:), '.r')
if normalize
    title('Plot då endast good\_points visas, kamera 2, normalized')
else
    title('Plot då endast good\_points visas, kamera 2')
end

%% 3D plot:
figure(7)
clf;
plot3(X(1,:), X(2,:), X(3,:),'.')
hold on;
load compEx3data.mat
plot3([ Xmodel(1,startind );  Xmodel(1,endind )],...
[Xmodel(2,startind );  Xmodel(2,endind )],...
[Xmodel(3,startind );  Xmodel(3,endind)],'b-');

[a, v] = camera_info(P1);
quiver3(a(1),a(2),a(3),v(1),v(2),v(3),1500,'r')

[a, v] = camera_info(P2);
quiver3(a(1),a(2),a(3),v(1),v(2),v(3),1500,'r')
hold on;
if normalize
    title('3D-punkter när outliers tagits bort, normalized')
else
    title('3D-punkter när outliers tagits bort')
end
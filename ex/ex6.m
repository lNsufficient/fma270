clear;

im1 = imread('mods/cars1.jpg');
im2 = imread('mods/cars2.jpg');
%im1 = imread('../assign2/assignment2data/cube1.JPG');
%im2 = imread('../assign2/assignment2data/cube2.JPG');
%im1 = imread('mods/ex5a.jpg');
%im2 = imread('mods/ex5b.jpg');

figure(1);
clf;
imagesc(im1);

figure(2)
clf;
imagesc(im2);

%% Try to find a matching homography between the pictures

%% First, sift

%% Vl_sift the images...
[f1, d1] = vl_sift(single(rgb2gray(im1)));
[f2, d2] = vl_sift(single(rgb2gray(im2)));

matches = vl_ubcmatch(d1, d2);

x1_2rows = f1(1:2, matches(1,:));
x2_2rows = f2(1:2, matches(2,:));

features_1 = length(f1);
features_2 = length(f2);
matching_features = length(matches);

x1 = [x1_2rows; ones(1,matching_features)];
x2 = [x2_2rows; ones(1,matching_features)];
%% Check the result

perm = randperm(size(matches ,2));
perm = perm(1:20);
figure(10);
clf;
imagesc ([im1 im2]);
hold on;
plot([x1(1,perm);  x2(1,perm)+ size(im1 ,2)], ...
[x1(2,perm);  x2(2,perm)] ,'-', 'LineWidth', 3);
hold  off;


%% Ransac to find homography
nbrSets = 10000;
maxDist = 10;
bestInliers = 0;
N = matching_features;
k = 4;
for i = 1:nbrSets
    randind = randperm(N,k);
    
    H = getH(x1(:,randind), x2(:,randind));
    
    Hx1 = pflat(H*x1);
    dists = sqrt(sum((x2 - Hx1).^2, 1));
    inliers = dists <= maxDist;
    
    if sum(inliers) > sum(bestInliers)
        bestInliers = inliers;
        bestIndices = randind;
    end
end

sift_indices = matches(:,bestInliers);


figure(3)
clf;
imagesc(im1)
hold on;
plot(x1(1,bestInliers), x1(2,bestInliers),'ro', 'MarkerSize',20)
%vl_plotsiftdescriptor(d1(:,sift_indices(1,:)), f1(:,sift_indices(1,:)))
title(sum(bestInliers))

figure(4)
clf;
imagesc(im2)
hold on;
plot(x2(1,bestInliers), x2(2,bestInliers),'ro', 'MarkerSize',20)

%vl_plotsiftdescriptor(d2(:,sift_indices(2,:)), f2(:,sift_indices(2,:)))
%vl_plotsiftdescriptor(d2(:,sift_indices(2,:)))
title(sum(bestInliers))
bestInliers = bestInliers(1:20)

figure(11);
clf;
imagesc ([im1 im2]);
hold on;
plot([x1(1,bestInliers);  x2(1,bestInliers)+ size(im1 ,2)], ...
[x1(2,bestInliers);  x2(2,bestInliers)] ,'-', 'LineWidth', 3);
hold  off;
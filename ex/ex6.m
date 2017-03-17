restart = 1;

if restart
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
    edge_thresh = 10;
    peak_thresh = 1;
    [f1, d1] = vl_sift(single(rgb2gray(im1)), 'PeakThresh', peak_thresh); %Try adding pea
    %[f1, d1] = vl_sift(single(rgb2gray(im1)), 'edgethresh', edge_thresh); %Try adding pea
    [f2, d2] = vl_sift(single(rgb2gray(im2)), 'PeakThresh', peak_thresh);
    %[f2, d2] = vl_sift(single(rgb2gray(im2)), 'edgethresh', edge_thresh);
%%
    matches = vl_ubcmatch(d1, d2, 2);

    x1_2rows = f1(1:2, matches(1,:));
    x2_2rows = f2(1:2, matches(2,:));

    features_1 = length(f1);
    features_2 = length(f2);
    matching_features = length(matches)

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
end
%% Try to find fundamental matrix that fits to the points, using RANSAC
nbrSets = round(log(0.01)/log(1-1/4^4));
maxDist = 20;
bestInliers = 0;
N1 = getN(x1);
N2 = getN(x2);
N = matching_features;
k = 4;
for i = 1:nbrSets
    randind = randperm(N,k);
    
    F = getF_normalized(x1(:,randind), x2(:,randind), getN(x1(:,randind)), getN(x2(:,randind)),0); 
    F = getF_normalized(x1(:,randind), x2(:,randind), N1, N2,0);

    xfx = diag(x2'*F*x1);
    
    inliers = (abs(xfx) < maxDist);
    inliers = find(inliers);
    
    if numel(inliers) > numel(bestInliers)
        bestInliers = inliers;
        bestIndices = randind;
    end
end

F_best = getF_normalized(x1(:,bestInliers), x2(:,bestInliers), N1, N2,0);
xfx =diag(x2'*F_best*x1); 
bestInliers = find(abs(xfx) < 0.5);
figure(3)
plot(xfx);
figure(4)
hist(xfx);

nbrInliers = numel(bestInliers)
disp('done')
perm = randperm(nbrInliers, 20)
bestInliers_all = bestInliers;
bestInliers = bestInliers(perm);
figure(11);
clf;
imagesc ([im1 im2]);
hold on;
plot([x1(1,bestInliers);  x2(1,bestInliers)+ size(im1 ,2)], ...
[x1(2,bestInliers);  x2(2,bestInliers)] ,'-', 'LineWidth', 3);
hold  off;

%% Instead of homography, try to find cameras and 3d points, using RANSAC.
nbrSets = round(log(0.01)/log(1-1/4^4));
maxDist = 5;
bestInliers = 0;
N1 = getN(x1);
N2 = getN(x2);
N = matching_features;
k = 4;
for i = 1:nbrSets
    randind = randperm(N,k);
    
    F = getF_normalized(x1(:,randind), x2(:,randind), getN(x1(:,randind)), getN(x2(:,randind)),0); %Normalization not necessary because only 8 points. 
    F = getF_normalized(x1(:,randind), x2(:,randind), N1, N2,0); %Normalization not necessary because only 8 points. 
    [P1, P2] = get_cams_F(F);
    
    
    X = getX_normalized(P1, P2, N1, N2, x1, x2); %Do this for all points
    %X = getX(P1, P2, x1, x2);
    X = pflat(X);
    xp1 = pflat(P1*X);
    x1_dists = sqrt(sum((x1(1:2,:) - xp1(1:2,:)).^2,1));
    xp2 = pflat(P2*X);
    x2_dists = sqrt(sum((x2(1:2,:) - xp2(1:2,:)).^2,1));
    inliers = ((x1_dists < maxDist).*(x2_dists < maxDist));
    inliers = find(inliers);
    
    if numel(inliers) > numel(bestInliers)
        bestInliers = inliers;
        bestIndices = randind;
    end
    
end

N1_best = getN(x1(:,bestInliers));
N2_best = getN(x2(:,bestInliers));
F = getF_normalized(x1(:,bestInliers), x2(:,bestInliers), N1_best, N2_best); %Normalization not necessary because only 8 points.
[P1, P2] = get_cams_F(F);
X = getX_normalized(P1, P2, N1, N2, x1, x2); %Do this for all points
xp1 = pflat(P1*X);
x1_dists = sqrt(sum((x1(1:2,:) - xp1(1:2,:)).^2,1));
xp2 = pflat(P2*X);
x2_dists = sqrt(sum((x2(1:2,:) - xp2(1:2,:)).^2,1));
inliers = ((x1_dists < maxDist).*(x2_dists < maxDist));
inliers = find(inliers);
bestInliers = inliers;
P = {P1, P2};

% Plot the 3D-points
figure(12)
clf;
plot3(X(1,:), X(2,:), X(3,:), '.');
hold on;
% pause;
% plotcams(P);

figure(13)
clf;
imagesc(im1)
hold on;
plot(x1(1,:), x1(2,:),'bo')
plot(xp1(1,:), xp1(2,:),'r*')
%vl_plotsiftdescriptor(d1(:,sift_indices(1,:)), f1(:,sift_indices(1,:)))
title(sum(bestInliers))

% Plot the matches
figure(3)
clf;
imagesc(im1)
hold on;
plot(x1(1,bestInliers), x1(2,bestInliers),'bo', 'MarkerSize',20)
plot(xp1(1,bestInliers), xp1(2,bestInliers),'r*')
%vl_plotsiftdescriptor(d1(:,sift_indices(1,:)), f1(:,sift_indices(1,:)))
title(sum(bestInliers))

figure(4)
clf;
imagesc(im2)
hold on;
plot(x2(1,bestInliers), x2(2,bestInliers),'bo', 'MarkerSize',20)
plot(xp2(1,bestInliers), xp2(2,bestInliers),'r*')

figure(14)
clf;
imagesc(im2)
hold on;
plot(x2(1,:), x2(2,:),'bo')
plot(xp2(1,:), xp2(2,:),'r*')
%% Ransac to find homography
nbrSets = round(log(0.01)/log(1-1/4^4));
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



%% Plot the inliers
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

%bestInliers = bestInliers(1:20)

figure(11);
clf;
imagesc ([im1 im2]);
hold on;
plot([x1(1,bestInliers);  x2(1,bestInliers)+ size(im1 ,2)], ...
[x1(2,bestInliers);  x2(2,bestInliers)] ,'-', 'LineWidth', 3);
hold  off;


%% setup

clear;
load assignment4data\compEx1data.mat
im{1} = imread('assignment4data\house1.jpg');
im{2} = imread('assignment4data\house2.jpg');

nbrBins = 100;

%% Total least squares on all points

meanX = mean(X,2); %Computes the mean 3D point 
Xtilde = (X - repmat(meanX ,[1 size(X,2)])); %Subtracts the mean from the 3D points 
M = Xtilde(1:3,:)*Xtilde(1:3,:)'; %Computes the matrix from Exercise 2 
[V,D] = eig(M); %Computes eigenvalues and eigenvectors of M
[~, minind] = min(abs(diag(D)));
abc = V(:, minind);
a = abc(1); b = abc(2); c = abc(3);
d = -(abc(1)*meanX(1)+abc(2)*meanX(2)+abc(3)*meanX(3));
plane = [abc; d];
RMS = sqrt(sum((plane'*X).^2)/size(X,2)); %Computes the RMS error
% dists = sqrt((plane'*X).^2);
% figure(1);
% clf;
% hist(dists,nbrBins);
title('TotalLeastSquares on all points');
fprintf('RMS for total least squares= %f \n', RMS)
fprintf('norm of plane = %1.4f \n', norm(plane(1:3)))

%% Ransac stuff

nbrSets = 1000;
maxDist = 0.1;
bestInliers = 0;
N = length(X);
k = 3;
for i = nbrSets
    randind = randperm(N,k);
    plane = null(X(:,randind)');
    plane = plane./norm(plane(1:3));
    
    inliers = abs(plane'*pflat(X)) <= maxDist;
    
    if sum(inliers) > sum(bestInliers)
        bestInliers = inliers;
        bestIndices = randind;
    end
end

plane = null(X(:,bestIndices)');
plane = plane./norm(plane(1:3));
RMS = sqrt(sum((plane'*X).^2)/size(X,2)); %Computes the RMS error
dists = sqrt((plane'*X).^2);

for i = 1:2
    xp = pflat(P{i}*X(:,bestInliers));
    figure(i);
    clf;
    imagesc(im{i});
    hold on;
    plot(xp(1,:), xp(2,:), 'r.');
end

figure(3);
clf;
hist(dists,nbrBins);
title('Ransac plane');


ransacPlane = plane;
fprintf('===============================\n');
fprintf('RMS for null and ransac = %f\n', RMS);
fprintf('The number of inliers was %d\n', sum(bestInliers));
fprintf('norm of plane = %1.4f \n', norm(plane(1:3)))
fprintf('===============================\n');

%% Total least squares with inliers
X_inl = X(:,bestInliers);

meanX = mean(X_inl,2); %Computes the mean 3D point 
Xtilde = (X_inl - repmat(meanX ,[1 size(X_inl,2)])); %Subtracts the mean from the 3D points 
M = Xtilde(1:3,:)*Xtilde(1:3,:)'; %Computes the matrix from Exercise 2 
[V,D] = eig(M); %Computes eigenvalues and eigenvectors of M
[~, minind] = min(abs(diag(D)));
abc = V(:, minind);
a = abc(1); b = abc(2); c = abc(3);
d = -(abc(1)*meanX(1)+abc(2)*meanX(2)+abc(3)*meanX(3));
plane = [abc; d];
RMS = sqrt(sum((plane'*X).^2)/size(X,2)); %Computes the RMS error
dists = sqrt((plane'*X).^2);
figure(4);
clf;
hist(dists,nbrBins);
title('TotalLeastSquares on only inliers');

fprintf('RMS for TotalLeastSquares and ransac = %f\n', RMS);
fprintf('norm of plane = %1.4f \n', norm(plane(1:3)))
fprintf('===============================\n');

disp('total least squares minimizes the rms norm, so it is of course best to use it on the whole dataset');

%% Homography stuff
%Calibrate cameras
P{1} = K\P{1};
P{2} = K\P{2};

R = P{2}(1:3,1:3);
t = P{2}(1:3,end);
Pi = pflat(ransacPlane);
pi = Pi(1:3);
H = R - t*pi';

figure(5)
clf;
imagesc(im{1})
hold on;
px = pflat(x);
plot(px(1,:), px(2,:), 'b*');

figure(6)
clf;
imagesc(im{2})
hold on;
py = pflat(K*H*(K\x));
plot(py(1,:), py(2,:), 'r*');
title(sprintf('homography, %d inliers', sum(bestInliers)));
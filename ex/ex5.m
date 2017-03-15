clear;

im{1} = imread('mods/ex5a.jpg');
im{2} = imread('mods/ex5b.jpg');
im{3} = imread('mods/ex5c.jpg');
im{4} = imread('mods/ex5d.jpg');

for i = 1:4
    figure(i)
    clf;
    imagesc(im{i})
end

%% Get SIFT info

for i = 1:4
    [f{i}, d{i}] = vl_sift( single(rgb2gray(im{i})), 'PeakThresh', 1);
end

%% Trying to find homographies to transfer the images to eachother

i_prime = 2; %This figure seemed to some parts in common with all of the images

%% Trying to merge to images
ind_prime = 2; %these seem the most similar, for testing I will start with them
ind = 4
common_ind = ind_prime*10+ind;

matches{common_ind} = vl_ubcmatch(d{ind_prime}, d{ind})
%matches_tmp = vl_ubcmatch(d{ind_prime}, d{ind})
xA = f{ind_prime}(1:2, matches{common_ind}(1,:));
xB = f{ind}(1:2, matches{common_ind}(2,:));

matching_features = length(matches{common_ind});

%Pflat image points
xa = [xA; ones(1,matching_features)];
xb = [xB; ones(1,matching_features)];

%% Ransac to find their homography

nbrSets = 100;
maxDist = 5;
bestInliers = 0;
N = matching_features;
k = 4; %As few as possible to find the homography

for i = 1:nbrSets
    randind = randperm(N,k);
    
    H = getH(xa(:,randind), xb(:,randind));
    
    Hxa = pflat(H*xa);
    dists = sqrt(sum((xb - Hxa).^2, 1));
    inliers = dists <= maxDist;
    
    if sum(inliers) > sum(bestInliers)
        bestInliers = inliers;
        bestIndices = randind;
    end
end

nbr_inliers = sum(bestInliers)
%bestH = getH(xa(:,bestIndices), xb(:,bestIndices));
%should be done using normalization when it works
Na_bestInd = getN(xa(:,bestIndices));
Nb_bestInd = getN(xb(:,bestIndices));
bestH = getH(xa(:,bestIndices), xb(:,bestIndices), Na_bestInd, Nb_bestInd);

Hxa = pflat(H*xa);
dists = sqrt(sum((xb - Hxa).^2, 1));

Hs{common_ind} = bestH;

%% Transform A to B using the "useful matlab commands" in assign 4

tform = maketform('projective',bestH');
%Creates a transfomation  that  matlab  can use for  images
%Note: imtransform  uses  the  transposed  homography
transfbounds = findbounds(tform ,[1 1; size(im{ind_prime},2)  size(im{ind_prime} ,1)]);
%Finds  the  bounds  of the  transformed  image
xdata = [min([ transfbounds(:,1); 1]) max([ transfbounds(:,1);  size(im{ind} ,2)])];
ydata = [min([ transfbounds(:,2); 1]) max([ transfbounds(:,2);  size(im{ind} ,1)])];
%Computes  bounds  of a new  image  such  that  both  the old  ones  will  fit.
[newA] = imtransform(im{ind_prime},tform ,'xdata',xdata ,'ydata',ydata);
%Transform  the  image  using  bestH
tform2 = maketform('projective',eye(3));
[newB] = imtransform(im{ind},tform2 ,'xdata',xdata ,'ydata',ydata ,'size',size(newA ));
%Creates a larger  version  of B
newAB = newB;
newAB(newB < newA) = newA(newB < newA);
%Writes  both  images  in the new  image. %(A somewhat  hacky  solution  is  needed
%since  pixels  outside  the  valid  image  area  are not  allways  zero ...)

figure(common_ind+1)
imagesc(newAB)
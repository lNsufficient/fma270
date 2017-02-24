clear;

%Add vl_sift
run('/home/edvard/vlfeat-0.9.20/toolbox/vl_setup.m');

%Load images
A = imread('assignment4data/a.jpg');
B = imread('assignment4data/b.jpg');

%% Vl_sift the images...
[fA, dA] = vl_sift(single(rgb2gray(A)));
[fB, dB] = vl_sift(single(rgb2gray(B)));

matches = vl_ubcmatch(dA, dB);

xA = fA(1:2, matches(1,:));
xB = fB(1:2, matches(2,:));

features_A = length(fA)
features_B = length(fB)
matching_features = length(matches)

%% Ransac to find homography
xa = [xA; ones(1,matching_features)];
xb = [xB; ones(1,matching_features)];

nbrSets = 100;
maxDist = 5;
bestInliers = 0;
N = matching_features;
k = 4;
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
bestH = getH(xa(:,bestIndices), xb(:,bestIndices));
Hxa = pflat(H*xa);
dists = sqrt(sum((xb - Hxa).^2, 1));


%% Transform A to B using the "useful matlab commands"...

tform = maketform('projective',bestH');
%Creates a transfomation  that  matlab  can use for  images
%Note: imtransform  uses  the  transposed  homography
transfbounds = findbounds(tform ,[1 1; size(A,2)  size(A ,1)]);
%Finds  the  bounds  of the  transformed  image
xdata = [min([ transfbounds(:,1); 1]) max([ transfbounds(:,1);  size(B ,2)])];
ydata = [min([ transfbounds(:,2); 1]) max([ transfbounds(:,2);  size(B ,1)])];
%Computes  bounds  of a new  image  such  that  both  the old  ones  will  fit.
[newA] = imtransform(A,tform ,'xdata',xdata ,'ydata',ydata);
%Transform  the  image  using  bestH
tform2 = maketform('projective',eye(3));
[newB] = imtransform(B,tform2 ,'xdata',xdata ,'ydata',ydata ,'size',size(newA ));
%Creates a larger  version  of B
newAB = newB;
newAB(newB < newA) = newA(newB < newA);
%Writes  both  images  in the new  image. %(A somewhat  hacky  solution  is  needed
%since  pixels  outside  the  valid  image  area  are not  allways  zero ...)

imagesc(newAB)

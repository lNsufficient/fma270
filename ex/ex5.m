clear;
%load('ex5_calculations')

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
for ind_prime = 1:4
    for ind = 1:4
        if ind == ind_prime
            continue;
        end
        common_ind = ind_prime*10+ind;

        matches{common_ind} = vl_ubcmatch(d{ind_prime}, d{ind});
        %matches_tmp = vl_ubcmatch(d{ind_prime}, d{ind})
        xA = f{ind_prime}(1:2, matches{common_ind}(1,:));
        xB = f{ind_prime}(1:2, matches{common_ind}(1,:));
        xA = f{ind}(1:2, matches{common_ind}(2,:));

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
        transfbounds = findbounds(tform ,[1 1; size(im{ind},2)  size(im{ind} ,1)]);
        %Finds  the  bounds  of the  transformed  image
        xdata = [min([ transfbounds(:,1); 1]) max([ transfbounds(:,1);  size(im{ind_prime} ,2)])];
        ydata = [min([ transfbounds(:,2); 1]) max([ transfbounds(:,2);  size(im{ind_prime} ,1)])];
        %Computes  bounds  of a new  image  such  that  both  the old  ones  will  fit.
        [newA] = imtransform(im{ind},tform ,'xdata',xdata ,'ydata',ydata);
        %Transform  the  image  using  bestH
        tform2 = maketform('projective',eye(3));
        [newB] = imtransform(im{ind_prime},tform2 ,'xdata',xdata ,'ydata',ydata ,'size',size(newA ));
        %Creates a larger  version  of B
        newAB = newB;
        newAB(newB < newA) = newA(newB < newA);
        %Writes  both  images  in the new  image. %(A somewhat  hacky  solution  is  needed
        %since  pixels  outside  the  valid  image  area  are not  allways  zero ...)

        figure(common_ind)
        imagesc(newAB)
        merged_ims{common_ind} = newAB
    end
end
save('ex5_calculations', 'Hs', 'matches', 'merged_ims')

%% Show all in one figure 
%All images has to be included once, meaning each image provides one
%transf.
%It was found that all images was looking good when transferred to image2:
%I will therefore just merge all these images together. 

h21 = Hs{21};
h23 = Hs{23};
h24 = Hs{24};

%% Transform A1 A2 A3 to B using the "useful matlab commands" in assign 4

tform1 = maketform('projective',h21');
tform3 = maketform('projective',h23');
tform4 = maketform('projective',h24');
%Creates a transfomation  that  matlab  can use for  images
%Note: imtransform  uses  the  transposed  homography
transfbounds1 = findbounds(tform1 ,[1 1; size(im{1},2)  size(im{1} ,1)]);
transfbounds3 = findbounds(tform3 ,[1 1; size(im{3},2)  size(im{3} ,1)]);
transfbounds4 = findbounds(tform4 ,[1 1; size(im{4},2)  size(im{4} ,1)]);

transfbounds = [transfbounds1; transfbounds3; transfbounds4];
%Finds  the  bounds  of the  transformed  image
xdata = [min([ transfbounds(:,1); 1]) max([ transfbounds(:,1);  size(im{2} ,2)])];
ydata = [min([ transfbounds(:,2); 1]) max([ transfbounds(:,2);  size(im{2} ,1)])];
%Computes  bounds  of a new  image  such  that  both  the old  ones  will  fit.
[new1] = imtransform(im{1},tform1 ,'xdata',xdata ,'ydata',ydata);
[new3] = imtransform(im{3},tform3 ,'xdata',xdata ,'ydata',ydata);
[new4] = imtransform(im{4},tform4 ,'xdata',xdata ,'ydata',ydata);
%Transform  the  image  using  bestH
tform2 = maketform('projective',eye(3));
[new2] = imtransform(im{2},tform2 ,'xdata',xdata ,'ydata',ydata ,'size',size(new1));
%Creates a larger  version  of B
new21 = new2;
new21(new2 < new1) = new1(new2 < new1);
%Writes  both  images  in the new  image. %(A somewhat  hacky  solution  is  needed
%since  pixels  outside  the  valid  image  area  are not  allways  zero ...)

figure(121)
imagesc(new21)

new213 = new21;
new213(new21 < new3) = new3(new21 < new3);

figure(123)
imagesc(new213);

new2134 = new213;
new2134(new213 < new4) = new4(new213 < new4);

figure(124)
imagesc(new2134)

save('ex5_end_image', 'new2134')

%% Further improvements:
%Maybe find the homography from the complete image new2134 to a paper of
%size a4. This gives the homography that then can be applied to all other
%homographies so that they instead transfer to this a4 paper.
%One way to do this would be to take a photo of any white paper, and then
%try to match the corners of the paper. A lot easier would be to take an
%image of the same page, and try to find the homography using simp, which
%should be easy. Then that image can be "thrown away", so it is not used to
%merge together pieces, only the homography will be used.

%Another way to improve results would be to instead transfer to the image
%showing only the top right corner of the paper. This perspective is nicer,
%so if all images could be transferred here, the result might be better. In
%order to do so, all that is needed is one good homography from one other
%picture to this perspective (the only good homography that was found for
%this was h32), and then create h34 = h32*h24, for example.
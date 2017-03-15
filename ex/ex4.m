clear;

load 'mods/ex4data.mat'

%[~, ~, U, V] = getE(x{1}, x{2}, K, 1); %Plot the result to verify
[~, ~, U, V] = getE(x{1}, x{2}, K);

P1 = [eye(3) zeros(3,1)];
P2 = p_Ess(U, V);

X_all = cell(4,1);
P = cell(2,1);
P{1} = P1;

x1_tilde = K\x{1};
%hist(x1_tilde(3,:)) bara ettor
x2_tilde = K\x{2};
%hist(x2_tilde(3,:)) bara ettor.

best_good_points = 0;

for i = 1:4
    X = getX(P1, P2{i}, x1_tilde, x2_tilde);
    P{2} = P2{i};
    X_all{i} = X;
    
    figure(i)
    clf;
    plot3(X(1,:), X(2,:), X(3,:), '.');
    hold on;
    plotcams(P);
    
    
    px2 = P2{i}*X;
    totPoints = length(px2);
    gp2 = sum(px2(end,:) > 0)/totPoints;
    
    px1 = P1*X;
    gp1 = sum(px1(end,:) > 0)/totPoints;
    
    if (gp2>0.5) && (gp1 > 0.5)
        disp(sprintf('good points, kamera %d', i))

    else
        disp('bad points')
    end
    
    tot_good_points = gp1 + gp2;
    if best_good_points < tot_good_points
        best_good_points = tot_good_points;
        best_camera = i;
    end
end

%Apparently, camera 4 was the best one, all others had more points behind
%than in front of the camera.
%%
P1 = P{1};
P2 = P2{best_camera};
P{2} = P2;

X = getX(P1, P2, x1_tilde, x2_tilde);

figure(5)
clf;
plot3(X(1,:), X(2,:), X(3,:), '.');
hold on;
plotcams(P);

%%
im1 = imread('mods/gbg1.jpg');

figure(6);
clf;
imagesc(im1);

hold on;
plot(kp1(1,:), kp1(2,:), 'r')
plot(p1(1,:), p1(2,:), 'g')
%%
im2 = imread('mods/gbg2.jpg');

figure(7);
clf;
imagesc(im2);

hold on;
plot(kp2(1,:), kp2(2,:), 'r')
plot(p2(1,:), p2(2,:), 'g')
%%
kp1_pf = [kp1; ones(1,size(kp1,2))];
kp2_pf = [kp2; ones(1,size(kp2,2))];
p1_pf = [p1; ones(1,size(p1,2))];
p2_pf = [p2; ones(1,size(p2,2))];

kp1_tilde = K\kp1_pf;
kp2_tilde = K\kp2_pf;
p1_tilde = K\p1_pf;
p2_tilde = K\p2_pf;

X_kp = getX(P1, P2, kp1_tilde, kp2_tilde);
X_p = getX(P1, P2, p1_tilde, p2_tilde);
figure(5)

plot3(X_kp(1,:), X_kp(2,:), X_kp(3,:), 'r.', 'MarkerSize', 20);
plot3(X_p(1,:), X_p(2,:), X_p(3,:), 'g.', 'MarkerSize', 20);

X_kp_dist = sqrt(sum((X_kp(1:3,1) - X_kp(1:3,2)).^2));
corr_dist = 20;
s = corr_dist/X_kp_dist;
X_kp_scaled = X_kp*s;
dist_scaled = sqrt(sum((X_kp_scaled(1:3,1)-X_kp_scaled(1:3,2)).^2))

X_p_scaled = X_p*s;



%% 
X_scaled = X*s;

figure(8)
clf;
plot3(X_scaled(1,:), X_scaled(2,:), X_scaled(3,:), '.');
hold on;
plotcams(P);
plot3(X_kp_scaled(1,:), X_kp_scaled(2,:), X_kp_scaled(3,:), 'r.', 'MarkerSize', 20);
plot3(X_p_scaled(1,:), X_p_scaled(2,:), X_p_scaled(3,:), 'g.', 'MarkerSize', 20);

X_p_scaled_dist = sqrt(sum((X_p_scaled(1:3,1) -X_p_scaled(1:3,2)).^2))

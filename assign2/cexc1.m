clear all;

addpath assignment2data

%load 'assignment2data/compEx1data.mat';
load 'compEx1data.mat';


%% 3D plot
X_h = pflat(X);

figure(1)
plot3(X(1,:), X(2,:), X(3,:), '.g')
hold on; 
plotcams(P)
axis equal;

%% Image and projected points
i = 2;

xi = x{i};
xi_h = pflat(xi);
xpi = P{i}*X;
xpi_h = pflat(xpi);
Ii = imread(imfiles{i});


figure(2)
imagesc(Ii);
hold on;
plot(xi_h(1,:), xi_h(2,:), '.b');

plot(xpi_h(1,:), xpi_h(2,:), '.r');

%% Using projective transformations

%calculate all the things
T = cell(2);
T{1} = [1 0 0 0; 0 4 0 0 ; 0 0 1 0; 1/10 1/10 0 1];
T{2} = eye(4);
T{2}(end, 1:2) = [1/16 1/16];

Pnew = P;
N = 2;
M = 9;
X_new = cell(N,1);
P_new = cell(N,1);

for j = 1:N
    Tj = T{j};
    X_new{j} =Tj*X;
    X_new{j} = pflat(X_new{j});
    %get the new cameras
    Pj = P;
    for i = 1:M
        Pj{i} = Pj{i}/Tj;
    end
    P_new{j} = Pj;
end

%plot all the things.
for j = 1:N
    figure(2+j)
    Xj = X_new{j};
    Xj = pflat(Xj);
    plot3(Xj(1,:), Xj(2,:), Xj(3,:), '.b')
    hold on;
    plotcams(P_new{j});
end

% J = 2 correspond to the best points.
figure(5)
j = 2;
Xj = X_new{j};
P_newj = P_new{j};
i = 2;

Pji = P_newj{i};
xji_p = pflat(Pji*Xj);

xji = x{i};

Ii = imread(imfiles{i});
imagesc(Ii);

imagesc(Ii);
hold on;
plot(xji(1,:), xji(2,:), '.b');
plot(xji_p(1,:), xji_p(2,:), '.r');
axis equal;

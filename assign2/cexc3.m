clear;
addpath 'assignment2data'
load compEx3data.mat

plot3(Xmodel(1,:), Xmodel(2,:), Xmodel(3,:), '.')

meanX = mean(Xmodel,2);
X_std= std(Xmodel,0,2);


% [mx, nx] = size(x);
% nbr_images = mx*nx;
% meanx = zeros(3,nbr_images);
% stdx = meanx;
xLong = [x{1}, x{2}];
% for i = 1: nbr_images
%     meanx(:,i) = mean(x{i},2);
%     stdx(:,i) = std(x{i},0,2);
% end

meanx = mean(xLong,2);
meanx = meanx(1:2);
stdx = std(xLong,0,2);
stdx = stdx(1:2);

s = 1./stdx;
N = diag([s; 1]);
%N = eye(4);

N(1:2,end) = -meanx.*s;
i = 1;
xi = N*x{i};



Xmodel_h = [Xmodel; ones(1, size(Xmodel,2))];
%För första kameran:
P = cell(2,1);
for i = 1:2
    Mi = getM(Xmodel_h, x{i}, N);
    [~, S, V] = svd(Mi);
    s_min = max(S(:,end));
    smallest_sing_squared = s_min^2
    sol = V(:,end);
    mv_norm = sqrt(sol'*Mi'*Mi*sol)
    p = sol(1:12);
    Pi = getP(p, N);
    a = (Pi*Xmodel_h(:,1));
    a = sign(a(end,1));
    P{i} = Pi*a;
end
figure(3)
clf;
plot3([ Xmodel(1,startind );  Xmodel(1,endind )],...
[Xmodel(2,startind );  Xmodel(2,endind )],...
[Xmodel(3,startind );  Xmodel(3,endind)],'b-');
hold on;
for i = 1:2
xpi = P{i}*Xmodel_h; 

xp = pflat(xpi);
figure(i)
clf;
str = sprintf('Kamera %d', i)

plot(x{i}(1,:), x{i}(2,:), 'b.', 'Markersize', 10)
hold on;
plot(xp(1,:), xp(2,:), 'r.')
title(str);
legend('givna', 'projicerade')

%Plot the camera axis and startpoint
figure(3)
[a, v] = camera_info(P{i});
quiver3(a(1),a(2),a(3),v(1),v(2),v(3),1500,'r')
end

[f, xp, gamma, skew] = getCamParams(P{i})


clear;
addpath 'assignment1data'
im1 = imread('CompEx5.jpg');
load 'compEx5.mat';

%% Plotta figuren som den är med sina hörnpunkter

figure(1)
imagesc(im1);
colormap 'gray';
hold on
%corners har 1 i sista rad
plot(corners (1,[1:end 1]), corners (2,[1:end 1]),'*r-');
axis equal;

%% Plotta hörnpunkterna när de normaliserats:

corn_norm = K\corners;

figure(2);
plot(corn_norm(1,[1:end 1]), corn_norm(2,[1:end 1]),'*r-');
axis ij;
axis equal;

%% Beräknar 3D-punkter

v_pf = pflat(v);
U = [corn_norm; -v_pf(1:3)'*corn_norm];

U = pflat(U);
P1 = [eye(3), zeros(3,1)];
[cam_cent, principal] = camera_info(P1);

figure(3)
clf;
plot3(U(1,:), U(2,:), U(3,:), '.')
hold on
quiver3(cam_cent(1), cam_cent(2), cam_cent(3), principal(1), principal(2), principal(3), 1)

%% Beräknar P2:
cam2 = [2, 0, 0]';

% sätter null space(P) till cam2:
% [R t][cam2; 1] = 0 => R*cam2 + t = 0 => t = -R*cam2;.

R = [sqrt(3)/2, 0, 1/2; 0 1 0; -1/2 0 sqrt(3)/2];
t = -R*cam2;

P2 = [R, t];

[cam_cent2, principal2] = camera_info(P2);
figure(3);
quiver3(cam_cent2(1), cam_cent2(2), cam_cent2(3), principal2(1), principal2(2), principal2(3), 1,'b')
axis equal

%% Beräknar homography och beräknar y

H = [R - t*v_pf(1:3)'];
y = pflat(H*corn_norm);
yp = pflat(P2*U);
figure(4);
plot(y(1,[1:end 1]), y(2,[1:end 1]),'*r-', 'MarkerSize', 12);
hold on;
plot(yp(1,[1:end 1]), yp(2,[1:end 1]),'*b-')
axis ij;
axis equal;

%%
Htot = K*H/K;
tform = maketform('projective',Htot');
%Creates a projective  transformation  that  can be used in  imtransform
%NOTE: Matlab  uses  the  transposed  version  of the  homografi.

[new_im ,xdata ,ydata] = imtransform(im1,tform ,'size',size(im1));
%Creastes a transformed  image (using  tform)
%of the  same  size as the  original  one.
figure(5)
imagesc(xdata ,ydata ,new_im );
axis equal
%plots  the new  image  with  xdata  and  ydata on the  axes
colormap 'gray'
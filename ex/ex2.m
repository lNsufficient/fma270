clear;
load 'mods/ex2data.mat'

%% Calculates the homography
%It is important that the homography takes the "world" plane and transforms
%it to the projected plane, otherwise, the information about the focal
%length is not there the way I want it to.

%Calculate homography when NOT normalizing
H_not_normalized = getH(u1, u2)

u2_sum = sum(sum(abs(u2)));
u2_max = max(max(abs(u2)))

H = H_not_normalized;
diff1 = u2 - pflat(H*u1);
diff1_sum = sum(sum(abs(diff1)));
diff1_max = max(max(abs(diff1)))

dev1 = diff1_sum/u2_sum

%Calculate homography when USING normalization
N1 = getN(u1); N2 = getN(u2);
H_normalized = getH(u1, u2, N1, N2)

H = H_normalized
diff2 = u2 - pflat(H*u1);
diff2_sum = sum(sum(abs(diff2)));

diff2_max = max(max(abs(diff2)))

dev2 = diff2_sum/u2_sum

%It seems like normalized gives better result. From diff2_max it does not
%seem like there are any outliers? (Maybe this has to be checked using
%ransac but if diff2_max = 5.2420, when u2_max = 688.46, then it seems
%okay.
H = H_normalized

%% Get the camera's focal length

H2 = H.^2;
A = [1 - H2(3,1); 1 - H2(3,2); -H(3,1)*H(3,2)];
A = [1 - H(3,1)*H(3,1); 1 - H(3,2)*H(3,2); - H(3,1)*H(3,2)];
b = [H2(1,1)+H2(2,1); H2(1,2) + H2(2,2); H(1,1)*H(1,2)+H(2,1)*H(2,2)];
b = [H(1:2,1)'*H(1:2,1); H(1:2,2)'*H(1:2,2); H(1:2,1)'*H(1:2,2)]

%Solve the normal equation f = (A^T*A)\A^T*b
f2 = A\b; %Has to be positive?
f = sqrt(f2);

%% Test the solution

test = A*f2 - b

R1 = [H(1,1)/f; H(2,1)/f; H(3,1)];
R2 = [H(1,2)/f; H(2,2)/f; H(3,2)];

R1_squared = R1'*R1
R2_squared = R2'*R2
R12 = R1'*R2

F = eye(3); 
F(3,3) = f;

A = F*H;
A'*A - eye(3)*f %Should have zeros in top (2,2) square
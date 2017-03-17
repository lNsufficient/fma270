%This script was used to verify my results from exercise 1. 

P = [2 0 1 -1; 2 1 -1 0; 0 0 1 0];

X1 = [2; 2; 2; 1];
X2 = [1; 1; 0; 1];
X3 = [1; 2; 3; 0];

px1 = P*X1
px2 = P*X2
px3 = P*X3

[cam_cent, princ_axis] = camera_info(P)
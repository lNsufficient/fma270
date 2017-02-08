clear;

load compEx3data.mat

plot3(Xmodel(1,:), Xmodel(2,:), Xmodel(3,:), '.')

meanX = mean(Xmodel,2);
X_tilde = [Xmodel(1,:) - meanX(1); Xmodel(2,:) - meanX(2); Xmodel(3,:) - meanX(3)];

X_std= std(X_tilde');
X_tilde = diag(1./X_std)*X_tilde;
%X_tilde = X_tilde';

plot3(X_tilde(1,:), X_tilde(2,:), X_tilde(3,:), '.')
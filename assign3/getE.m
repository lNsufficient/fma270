function [E, E_tilde] = getE(x1, x2, K)
%GETE Summary of this function goes here
%   Detailed explanation goes here


x1_tilde = K\x1;
x2_tilde = K\x2;

E_tilde = getF(x1_tilde, x2_tilde);
%Test gav att x2'*F*x1 storleksordning 0.001, medan x2'*x1 ungefär 1.


[U,S,V] = svd(E_tilde); 
if det(U*V')>0 
    E_tilde = U*diag([1 1 0])*V'; 
else V = -V; 
    E_tilde = U*diag([1 1 0])*V';
end % Creates a valid essential matrix from an approximate solution. 
% Note: Computing svd on E may still give U and V that does not fulfill 
% det(U*V’) = 1 since the svd is not unique. 
% So don’t recompute the svd after this step.

E = K'\E_tilde/K;
%E = E./E(3,3);
end


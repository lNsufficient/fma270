function [E, E_tilde, U, V] = getE(x1, x2, K, do_plot)
%GETE Calculates E matrix

if nargin < 4
    do_plot = 0;
end


x1_tilde = K\x1;
x2_tilde = K\x2;

E_tilde = getF(x1_tilde, x2_tilde);

if do_plot
    plot(diag(x2_tilde'*E_tilde*x1_tilde));
    title('E_tilde, x_tilde, s NOT [1 1 0]')
    pause;
end


[U,S,V] = svd(E_tilde); 
if det(U*V')>0 
    E_tilde = U*diag([1 1 0])*V'; 
else V = -V; 
    E_tilde = U*diag([1 1 0])*V';
end % Creates a valid essential matrix from an approximate solution. 
% Note: Computing svd on E may still give U and V that does not fulfill 
% det(U*V�) = 1 since the svd is not unique. 
% So don�t recompute the svd after this step.

if do_plot
    plot(diag(x2_tilde'*E_tilde*x1_tilde));
    title('E_tilde, x_tilde, s IS [1 1 0]')
    pause;
end

E = K'\E_tilde/K;

if do_plot
    plot(diag(x2'*E*x1));
    title('E_tilde, x_tilde, s IS [1 1 0]')
    pause;
end


%E = E./E(3,3);
end


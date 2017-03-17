function [F, F_tilde] = getF_normalized(x1, x2, N1, N2, do_plot)
%GETF_NORMALIZED calculates the F matrix using normalization and forcing
%last svd to be 0. 

if nargin < 5
    do_plot = 0;
end

if nargin < 3
    N1 = eye(3);
    N2 = eye(3);
end

x1_tilde = N1*x1;
x2_tilde = N2*x2;

F_tilde = getF(x1_tilde, x2_tilde);

[U, S, V] = svd(F_tilde);
S(3,3) = 0;

F_tilde = U*diag([S(1,1), S(2,2), 0])*V';

if do_plot
    figure(20)
    clf;
    plot(diag(x2_tilde'*F_tilde*x1_tilde));
    title('F_tilde')
    pause;
end

F = N2'*F_tilde*N1;

if do_plot
    figure(20)
    clf;
    plot(diag(x2'*F*x1));
    title('F')
    pause;
end




end


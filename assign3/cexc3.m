function cexc3()
%CEXC3 Computer Excercise 3.

addpath 'assignment3data';
load compEx1data.mat;
load compEx3data.mat;

x1 = x{1};
x2 = x{2};

x1_tilde = K\x1;
x2_tilde = K\x2;

%% Get E and E tilde
% %=====START======
% x1_tilde = K\x1;
% x2_tilde = K\x2;
% 
% E_tilde = getF(x1_tilde, x2_tilde);
% %Test gav att x2'*F*x1 storleksordning 0.001, medan x2'*x1 ungefär 1.
% 
% 
% [U,S,V] = svd(E_tilde); 
% if det(U*V')>0 
%     E_tilde = U*diag([1 1 0])*V'; 
% else V = -V; 
%     E_tilde = U*diag([1 1 0])*V';
% end % Creates a valid essential matrix from an approximate solution. 
% % Note: Computing svd on E may still give U and V that does not fulfill 
% % det(U*V’) = 1 since the svd is not unique. 
% % So don’t recompute the svd after this step.¨
% 

[E, E_tilde] = getE(x1, x2, K);
figure(1)
plot(diag(x2_tilde'*E_tilde*x1_tilde));
title('matchningar i Essential matrix')

%E = K'\E/K;
%=====END======

figure(2)
clf
plot(diag(x2'*E*x1));
title('matchningar i Fundamental matrix')

%% Rita linjer
l = E*x1;
l = l./sqrt(repmat(l(1,:).^2 + l(2 ,:).^2 ,[3 1]));
% Makes sure that the line has a unit normal
%( makes the distance formula easier )
I = imread('kronan2.JPG');
figure(3)
imagesc(I)
hold on;
title('kronan2')

m = randperm(size(l,2));
m = m(1:20);
l_test = l(:,m);

x2_plot = pflat(x2);
plot(x2_plot(1,m), x2_plot(2,m), '*r')
rital(l_test)


figure(4);
hist(abs(sum(l.*x2)),100);
title('histogram för Fundamental som hittats med Essential')

format shorteng
disp(E./E(3,3))
%% Export to computer excercise 4

save('cexc3Data', 'E_tilde', 'K', 'x1', 'x2');


end


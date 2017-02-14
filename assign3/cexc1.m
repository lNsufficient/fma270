function cexc1()
%CEXC1 Computer Excercise 1.
addpath 'assignment3data';
load compEx1data.mat;

x1 = x{1};
x2 = x{2};

N1 = getN(x1);
N2 = getN(x2);

x1_tilde = N1*x1;
x2_tilde = N2*x2;

F_tilde = getF(x1_tilde, x2_tilde);
%Test gav att x2'*F*x1 storleksordning 0.001, medan x2'*x1 ungefär 1.

F = N2'*F_tilde*N1;

figure(1)
plot(diag(x2'*F*x1));

l = F*x1;
l = l./sqrt(repmat(l(1,:).^2 + l(2 ,:).^2 ,[3 1]));
% Makes sure that the line has a unit normal
%( makes the distance formula easier )
I = imread('kronan2.JPG');
figure(2)
imagesc(I)
hold on;

m = randperm(size(l,2));
m = m(1:20);
l_test = l(:,m)

x2_plot = pflat(x2);
plot(x2_plot(1,m), x2_plot(2,m), '*r')
rital(l_test)


figure(3);
hist(abs(sum(l.*x2)),100);
% Computes all the the distances between the points
% and there corresponding lines , and plots in a histogram

save('exc1Data', 'F', 'F_tilde', 'N1', 'N2', 'x1', 'x2');

end

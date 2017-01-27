clear;
load 'assignment1data/compEx3.mat';

figure(5);
plot([ startpoints(1,:);  endpoints(1,:)], ...
    [startpoints(2,:);  endpoints(2,:)],'b-');

H1 = [sqrt(3), -1, 1; 1, sqrt(3), 1; 0, 0, 2];

H2 = [1, -1, 1; 1, 1, 0; 0, 0, 1];

H3 = [1, 1, 0; 0, 2, 0; 0, 0, 1];

H4 = [sqrt(3), -1, 1; 1, sqrt(3), 1; 1/4, 1/2, 2];

H = cell(3);
H{1} = H1;
H{2} = H2;
H{3} = H3;
H{4} = H4;

for i = 1:4
    figure(i);
[Hstart, Hend] = transfPoints(H{i}, startpoints, endpoints);

plot([Hstart(1,:); Hend(1,:)], [Hstart(2,:); Hend(2,:)], 'b-');
axis 'equal'
end
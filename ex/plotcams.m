function plotcams(P)
%COPIED FROM AN ASSIGNMENT WHERE IT WAS GIVEN TO US.

c = zeros(4,length(P));
v = zeros(3,length(P));
for i = 1:length(P);
    c(:,i) = null(P{i});
    v(:,i) = P{i}(3,1:3);
    v(:,i) = v(:,i)/(norm(v(:,i)));
end
c = c./repmat(c(4,:),[4 1]);
fac = 1;
% quiver3(c(1,:),c(2,:),c(3,:),v(1,:), v(2,:), v(3,:),fac,['r', '-'],'LineWidth',1.5,'MaxHeadSize',1.5);

quiver3(c(1,1),c(2,1),c(3,1),v(1,1), v(2,1), v(3,1),fac,['b','-'],'LineWidth',1.5,'MaxHeadSize',1.5);
quiver3(c(1,2),c(2,2),c(3,2),v(1,2), v(2,2), v(3,2),fac,['r','-'],'LineWidth',1.5,'MaxHeadSize',1.5);
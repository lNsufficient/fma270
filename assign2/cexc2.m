cexc1
%%


i = 2;
Kj_all = cell(N,1);
disp('i changes camera, j changes transformation that was used');
str = sprintf('K, for image %d, no transformation');
disp(str)
Kj = rq(P{i}(:,1:3));
Kj = Kj./Kj(3,3);
str = sprintf('K for image %d, no transformation', i);
disp(str);
disp(Kj)

for j = 1:N
    Pj = P_new{j};
    Pji = Pj{i};
    Kj = rq(Pji(:,1:3));
    Kj_all{j} = Kj./Kj(3,3);
    str = sprintf('K, for image %d and transformation %d \n', i, j);
    disp(str)
    disp(Kj)
    
end
    
j = 2;
Pj = P_new{j};
Ki_all = cell(M,1);
for i = 1:M
    Pji = Pj{i};
    Ki =rq(Pji);
    Ki_all{i} = Ki./Ki(3, 3);
    
    str = sprintf('K, for i = %d and j = %d \n', i, j);
    disp(str)
    disp(Ki)
end


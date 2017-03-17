function [P1, P2] = get_cams_F(F)
%GET_CAMS_F Returns P1 and P2 for a fundamental matrix
P1 = [eye(3) zeros(3,1)];

[~, ~, V] = svd(F');
e2 = V(:,end);

P2 = [cross_mat(e2)*F e2];


end


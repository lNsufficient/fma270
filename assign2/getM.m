function M = getM(X, x, N)
%GETM calculates the M matrix



x = N*x;
nbr_points = length(x);
dim = 3;
Mm = nbr_points*dim;
mX = size(X,1);
Mn = nbr_points + mX*dim;

M = zeros(Mm, Mn);
for i = 1:nbr_points
    start_row = (i-1)*3+1;
    start_col = 12+i;
    M(start_row:start_row+2, start_col) = x(:,i);
    for j = 1:3
        start_col_X = (j-1)*4+1;
        M(start_row+j-1,start_col_X:start_col_X+3) = X(:,i)';
    end
end

end


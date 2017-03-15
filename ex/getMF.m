function M = getMF(x1, x2)
%GETMF Returnerar M-matrisen som anv�nds f�r att finna F
% x1, x2 de bildpunkter som anv�nds

N = length(x1); %antar att N �r samma f�r b�da
%N borde vara 8?

M = zeros(N, 9);
for i = 1:N
    xx = x2(:,i)*x1(:,i)';
    M(i,:) = xx(:)';
end

end


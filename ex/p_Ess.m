function P = p_Ess(U, V)
%P_EXC6 returns the P matrices that are possible given for Essential matrix
W = [0, -1, 0; 1 0 0; 0 0 1];

P = cell(4,1);

u3 = U(:,3);
P{1} = [U*W*V' u3];
P{2} = [U*W*V' -u3];
P{3} = [U*W'*V' u3];
P{4} = [U*W'*V' -u3];

end


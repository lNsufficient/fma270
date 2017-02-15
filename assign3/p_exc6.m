function P = p_exc6(U, W, V)
%P_EXC6 returns the P matrices described in Excercise 6.

P = cell(4,1);

u3 = U(:,3);
P{1} = [U*W*V' u3];
P{2} = [U*W*V' -u3];
P{3} = [U*W'*V' u3];
P{4} = [U*W'*V' -u3];

end


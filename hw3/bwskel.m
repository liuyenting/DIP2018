function J = bwskel(I)
%BWSKEL Reduce all objects to lines in 2-D binary image.
%   Detailed explanation goes here

sz = size(I);

T = ones(sz+2) * -1;
T(2:sz(1)+1, 2:sz(2)+1) = I;
M = zeros(size(T));

sz = size(M);

figure();

modify = true;
while modify
    modify = false;
    for j = 3:sz(1)-2
        for i = 3:sz(2)-2
            m = min([T(j, i+1), T(j+1, i), T(j-1, i), T(j, i-1)]);
            M(j, i) = m+1;
        end
    end
    
    imagesc(M);
    drawnow;
    
    if ~isequal(M, T)
        T = M;
        modify = true;
    end
end

sz = size(I);
M = M(2:sz(1)+1, 2:sz(2)+1);

J = zeros(sz);
for j = 2:sz(1)-1
    for i = 2:sz(2)-1
        m = max([M(j, i+1), M(j+1, i), M(j-1, i), M(j, i-1)]);
        J(j, i) = M(j, i) == m;
    end
end

end

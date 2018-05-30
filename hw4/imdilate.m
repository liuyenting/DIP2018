function J = imdilate(I, SE)
%IMDILATE Summary of this function goes here
%   Detailed explanation goes here

[y, x] = size(I);
[q, p] = size(SE);

J = zeros(y,x);
for j = 1:y
    for i = 1:x
        if I(j, i) == 1
            for n = 1:p
                for m = 1:q
                    if SE(n,m) == 1
                        J(j+n, i+m)=1;
                    end
                end
            end
        end
    end
end

end


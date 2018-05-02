function de = bi2de(bi)
%BI2DE Convert binary vector to decimal number.
%   Detailed explanation goes here

de = 0;
m = 1;
for i = bi(end:-1:1)
    de = de + i*m;
    m = m*2;
end

end


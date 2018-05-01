function J = imerode(I, SE)
%IMERODE Erode image.
%   Detailed explanation goes here

sz = size(I);

ksz = size(SE);
r = ceil((ksz-1)/2);
is_even = ~mod(ksz, 2);

J = zeros(sz, 'double');
P = padarray(double(I), r, 'zero');

for j = 1:sz(2)
    for i = 1:sz(1)
        T = SE & P(j+is_even(1):j+2*r(1), i+is_even(2):i+2*r(2));
        J(j, i) = all(T(:));
    end
end

end


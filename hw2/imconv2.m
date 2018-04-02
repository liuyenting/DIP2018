function J = imconv2(I, K)
%IMCONV2 Convolve a kernel naively.
%   TBA

sz = size(I);

ksz = size(K);
r = ceil((ksz-1)/2);
is_even = ~mod(ksz, 2);

J = zeros(sz, 'double');

% pad the input with respect to the kernel size
P = padarray(double(I), r, 'mirror');

% convolve the data naively
for j = 1:sz(2)
    for i = 1:sz(1)
        % Simplify from 
        %   (j+r(1) - r(1) + is_even(1), j+r(1)+r(1)) -> )
        % to
        %   ((j + is_even(1), j+2*r(1))
        T = K .* P(j+is_even(1):j+2*r(1), i+is_even(2):i+2*r(2));
        J(j, i) = sum(T(:));
    end
end

end


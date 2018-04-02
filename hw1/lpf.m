function J = lpf(I, ksz)
%LPF Simple low-pass filter.
%   TBA 

if mod(ksz, 2) == 0
    error(generagemsgid('InvalidSize'), 'Kernel size should be odd.');
end
r = (ksz-1)/2;

sz = size(I);
dtype = class(I);
J = zeros(sz, 'like', I);

% zero-pad I
P = zeros(sz + ksz-1, 'like', I);
P(r+1:end-r, r+1:end-r) = I;

% convolve the data with equalization kernel naively
for j = 1:sz(2)
    for i = 1:sz(1)
        p = double(P(j:j+ksz-1, i:i+ksz-1));
        p = floor(mean(p(:)));
        J(j, i) = cast(p, dtype);
    end
end

end

function [H, varargout] = histogram(I, nbins)
%HISTOGRAM Create histogram for provided input.
%   TBA

I = I(:);
if ~isinteger(I)
    if sum(I < 0) > 0
        m = -1;
    else
        m = 0;
    end
    M = 1;
    I = double(I) / max(abs(I));
    nbins_def = 256;
else
    t = class(I);
    m = double(intmin(t));
    M = double(intmax(t));
    nbins_def = M-m+1;
end

if nargin < 2 
    nbins = nbins_def;
end

edges = linspace(m, M, nbins+1);

% build upper and lower bounds
lb = edges(1:end-1);
ub = edges(2:end);
ub(end) = ub(end) + eps;

H = zeros([1, nbins]);
for i = 1:nbins
    H(i) = sum( (I >= lb(i)) & (I < ub(i)) );
end

if nargout > 1
    varargout{1} = (edges(1:end-1) + edges(2:end)) / 2;
end

end


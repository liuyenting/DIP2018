function varargout = bwlabel(BW)
%BWLABEL Label connected components in 2-D binary image.
%   Detailed explanation goes here

SE = strel('square', 3);
sz = size(BW);
% label result
L = zeros(sz);
% number of connected components
N = 0;

I = BW;
% find first non-zero element
p = find(I == 1);
while ~isempty(p)
    N = N+1;
    
    p = p(1);
    X = false(sz);
    X(p) = true;
    
    
end

end

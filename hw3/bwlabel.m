function varargout = bwlabel(BW, debug)
%BWLABEL Label connected components in 2-D binary image.
%   Detailed explanation goes here

if nargin < 2
    debug = false;
end 

if debug
    f = figure('Name', 'bwlabel', 'NumberTitle', 'off');
end

SE = strel('square', 3);
sz = size(BW);
% label result
L = zeros(sz);
% number of connected components
N = 0;

A = BW;
% find first non-zero element
p = find(A);
while ~isempty(p)
    N = N+1;
    
    p = p(1);
    X = false(sz);
    X(p) = true;
    
    Y = A & imdilate(X, SE);
    while ~isequal(X, Y)
        X = Y;
        Y = A & imdilate(X, SE);
        
        if debug
            figure(f);
            imshow(Y);
            drawnow;
        end
    end
        
    % label all the Y
    p = find(Y == 1);
    L(p) = N;
    
    % remove labeled component
    A(p) = false;
    
    p = find(A);
end

varargout{1} = L;
if nargout == 2
    varargout{2} = N;
end

end

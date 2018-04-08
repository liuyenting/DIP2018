function [J, varargout] = bkgsub(I, r, smooth)
%BKGSUB Rolling ball background subtraction algorithm.
%   
%   J = BKGSUB(I, R, SMOOTH) subtracts the backround of I using rolling
%   ball algorithm with ball radius R. Median filter is applied if SMOOTH
%   is true.
%   [J, B] = BKGSUB(...) to return isolated background as B.

I = double(I);

if nargin < 3
    smooth = false;
end

ball = createball(r);
B = createbkg(I, smooth, ball);

J = I-B;
if nargout > 1
    varargout{1} = B;
end

end

function b = createball(r)
%CREATEBALL Create a ball structure element
%  
%   B = CREATEBALL(R) creates a structure element B of ball shape with
%   radius R.

if r <= 10
    b.factor = 1;
    trim = 24;
elseif r <= 30
    b.factor = 2;
    trim = 24;
elseif r <= 100
    b.factor = 4;
    trim = 32;
else
    b.factor = 8;
    trim = 40;
end

% ball size for downsampled result
r = r/b.factor;
if r < 1
    r = 1;
end

% edge pixels
xtrim = round(trim*r) / 100;
% half width
hw = round(r-xtrim);

% resulting width
b.width = 2*hw + 1;

[xv, yv] = meshgrid(-hw:hw, -hw:hw);
T = r*r - xv.*xv - yv.*yv;
T(T < 0) = 0;
b.data = sqrt(T);

end

function J = createbkg(I, smooth, ball)
%CREATEBKG Create background by rolling the ball
%
%   J = CREATEBKG(I, SMOOTH, BALL) generates background J by rolling a ball
%   structure element BALL on image I. If SMOOTH is true, median filter
%   with window size 3x3 is applied first.
%
%   Reference: Biomedical Image Processing, 10.1109/MC.1983.1654163

if smooth
    I = medfilt2(I, 3);
end

sz = size(I);

w = ball.width;
r = (w-1)/2;

K = ball.data / max(ball.data(:));
K = K * 255;

% erode
I = padarray(I, r, 'mirror');
J = zeros(sz, 'like', I);
for j = 1:sz(1)
    for i = 1:sz(2)
        T = I(j:j+2*r, i:i+2*r);
        T = T - K;
        
        J(j, i) = min(T(:));
    end
end

% dilate
I = padarray(J, r, 'mirror');
K = K / sum(K(:));
J = zeros(sz, 'like', I);
for j = 1:sz(1)
    for i = 1:sz(2)
        T = I(j:j+2*r, i:i+2*r);
        T = T .* K;
        J(j, i) = sum(T(:));
    end
end

end

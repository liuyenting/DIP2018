function J = bkgsub(I, r, opts)
%BKGSUB Rolling ball background subtraction algorithm.
%   TBA
%
%   Reference: ImageJ

if ~isa(I, 'uint8')
    error(generatemsgid('UnsupportedType'), 'Input image has to be uint8.');
end

if nargin < 3
    opts.invert = false;
    opts.smooth = false;
else
    if ~isfield(opts, 'invert')
        opts.invert = false;
    end
    if ~isfield(opts, 'smooth')
        opts.smooth = true;
    end
end
invert = opts.invert;
smooth = opts.smooth;

%TODO build ball
ball = createball(r);
B = createbkg(I, invert, smooth, ball);

if invert
    offset = 255.5;
else
    offset = 0.5;
end

% the actual subtraction
%   1) saturate overflow
%   2) subtract background
%   3) offset
%   4) remove overflow
J = int8(I) & 255 - (B + 255) + offset;
J(J < 0) = 0; J(J > 255) = 255;

end

function b = createball(r)

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
T = sqrt(T);

b.data = T(:);

end

function B = createbkg(I, invert, smooth, ball)
%CREATEBKG Create background by rolling the ball

if invert
    I = -I;
end

if smooth
    I = medfilt2(I, 3);
end

B = rollball(I, ball);

if invert
    B = -B;
end

end

function J = rollball(I, ball)
%ROLLBALL Rolls a filtering object over the image.

% sz = [height, width]
sz = size(I);
I = I(:);

z_ball = ball.data;
w = ball.width;
r = (w-1)/2;

cache = zeros([1, sz(2) * w]);
for y = -r:sz(1)+r-1
    % next line to read
    ln_r = y+r;
    % next line to write in cache
    ln_w = mod(ln_r, w);
    
    if ln_r <= sz(1)
        src = ln_r * sz(2);
        dst = ln_w * sz(2);
        cache(dst+1:dst+w) = I(src+1:src+w);
        I(ln_r*sz(2)+1:ln_r*sz(2)+w) = -inf;
    end
    
    % find out rolling offset
    y0 = y-r + 1;
    if y0 < 1
        y0 = 1;
    end
    yb0 = y0-y + r + 1;
    y1 = y+r;
    if y1 > sz(1)
        y1 = sz(1);
    end
    
    % roll over the scanline
    for x = -r:sz(2)+r-1
        z = inf;
        
        x0 = x-r + 1;
        if x0 < 1
            x0 = 1;
        end
        xb0 = x0-x + r + 1;
        x1 = x+r;
        if x1 > sz(2)
            x1 = sz(2);
        end
        yb1 = yb0;
        for yp = y0:y1
            % cache pointer
            cp = mod(yp, w) * sz(2) + x0;
            % ball pointer
            bp = xb0 + yb1*w;
            for xp = x0:x1
                % decrease in z-map
                try
                    z_r = cache(cp) - z_ball(bp);
                catch me
                    disp(['y=', num2str(y), ', x=', num2str(x)]);
                    disp(['yp=', num2str(yp), ', xp=', num2str(xp)]);
                    disp(['cp=', num2str(cp), ', bp=', num2str(bp)]);
                    rethrow(me);
                end
                % determine roll over or not
                if z > z_r 
                    z = z_r;
                end
                
                cp = cp+1;
                bp = bp+1;
            end
            yb1 = yb1+1;
        end
        
        yb1 = yb0;
        for yp = y0:y1
            p = x0 + yp*sz(2);
            bp = xb0 + yb1*w;
                
            % adjust z-map for minimum
            for xp = x0:x1
                z_min = z + z_ball(bp);
                if I(p) < z_min
                    I(p) = z_min;
                end
                
                p = p+1;
                bp = bp+1;
            end
            
            yb1 = yb1+1;
        end
    end
end

J = reshape(I, sz);

end

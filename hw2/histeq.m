function J = histeq(I, mode, varargin)
%HISTEQ Enhance contrast using histogram equalization.
%   HISTEQ(I) equalize the image I to better utilize its full data range.
%   Only integer types are supported.
%   HISTEQ(I, MODE, ...) to specify an algorithm for the equalization 
%   procedure, additional parameters can be provided afterward.
%
%   Notes: Currently MODE only supports 'global' or 'adaptive', unknown
%   options will fallback to 'global'.

if nargin > 2
    switch mode
        case 'adaptive'
            J = adapthisteq(I, varargin{:});
            return;
        case 'limited'
            J = limhisteq(I, varargin{:});
            return;
        case 'global'
            % noop
        otherwise
            warning(generatemsgid('InvalidMode'), ...
                    'Unknown equalization method, fallback to default.');
    end
end

J = inttr(I, @(x) x);

end

function J = adapthisteq(I, ksz)
%ADAPTHISTEQ Adaptive (local) histogram equalization.
%   TBA

if mod(ksz, 2) == 0
    error(generagemsgid('InvalidSize'), 'Kernel size should be odd.');
end
r = (ksz-1)/2;

sz = size(I);
J = zeros(sz, 'like', I);

% zero-pad I
P = zeros(sz + ksz-1, 'like', I);
P(r+1:end-r, r+1:end-r) = I;

% convolve the data with equalization kernel naively
for j = 1:sz(2)
    for i = 1:sz(1)
        H = histeq(P(j:j+ksz-1, i:i+ksz-1));
        J(j, i) = H(r+1, r+1);
    end
end

end

function J = limhisteq(I, ksz, slope)

if mod(ksz, 2) == 0
    error(generagemsgid('InvalidSize'), 'Kernel size should be odd.');
end
r = (ksz-1)/2;

dtype = class(I);
m = double(intmin(dtype));
M = double(intmax(dtype));

I = double(I);
I = I / max(I(:));

sz = size(I);
J = zeros(sz, 'like', I);

% zero-pad I
P = zeros(sz + ksz-1, 'like', I);
P(r+1:end-r, r+1:end-r) = I;

% convolve the data with equalization kernel naively
for j = 1:sz(2)
    for i = 1:sz(1)
        T = P(j:j+ksz-1, i:i+ksz-1);
        
        H = histogram(T);
        
        % calculate slope
        H0 = [H(1), H];
        H1 = [H, H(end)];
        dH = H1-H0;
        dH = (dH(1:end-1)+dH(2:end)) / 2;
        % clamp down
        mask = abs(dH) > slope;
        H(mask) = 0;
        
        % calculate the curve
        H = H / numel(H);
        H = cumsum(H);
        
        T = T/max(T(:));
        T = uint8(T * 255);
        
        % re-mapped
        T = (M-m) * H(T+1);
        % integers only
        T = floor(T);
        % shift downward for signed data types 
        T = T-m; 
        
        % use original data type
        J(j, i) = cast(T(r+1, r+1), dtype);
    end
end

end

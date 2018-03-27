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
        case 'global'
            % noop
        otherwise
            warning(generatemsgid('InvalidMode'), ...
                    'Unknown equalization method, fallback to default.');
    end
end

J = inttr(I, @(x) x);

end

function J = adapthisteq(I, r)
%ADAPTHISTEQ Adaptive (local) histogram equalization.
%   TBA

if mod(r, 2) == 0
    error(generagemsgid('InvalidSize'), 'Kernel radius should be even.');
end

sz = size(I);
J = zeros(sz, 'like', I);

% zero-pad I
P = zeros(sz + 2*r, 'like', I);
P(r+1:end-r, r+1:end-r) = I;

% convolve the data with equalization kernel naively
for j = 1:sz(2)
    for i = 1:sz(1)
        H = histeq(P(j:j+2*r, i:i+2*r));
        J(j, i) = H(r+1, r+1);
    end
end

end


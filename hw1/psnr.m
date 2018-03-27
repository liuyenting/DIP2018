function peaksnr = psnr(I, ref, peakval)
%PSNR Peak signal-to-noise ratio.
%   PEAKSNR = PSNR(I, REF) calcaultes the peak signal-to-noise ratio for
%   the image I, with the image in REF as the reference.
%
%   PEAKSNR = PSNR(I, REF, PEAKVAL) uses PEAKVAL as the peak signal value
%   for calculating the peak signal-to-noise ratio.

if nargin < 3
    dtype = class(I);
    peakval = double(intmax(dtype)) - double(intmin(dtype));
end

err = mse(I, ref);
peaksnr = 10 * log10(peakval.^2 / err); 

end

function err = mse(X, Y)
%MSE Mean-squared error.
%   TBA

if ~isa(X, class(Y))
    error(generatemsgid('DifferentClass'), ...
          'Arrays are of different types.');
end

if ~isequal(size(X), size(Y))
    error(generatemsgid('SizeMismatch'), 'Unequal array sizes.');
end

if isempty(X)
    error(generatemsgid('Empty'), 'Empty array, unable to calculate MSE.');
end

if isinteger(X)
    X = double(X);
    Y = double(Y);
end

% 2-norm
err = (norm(X(:)-Y(:), 2).^2) / numel(X);

end

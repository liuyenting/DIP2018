function C = fxcorr2(A, B)
%FXCORR2 Fast 2-D cross-correlation.
%
%   C = FXCORR2(A, B) performs cross-correlation upon image A and B. Size
%   of C is the maximum size of A and B on X and Y dimension.
%
%   See also: FFT2, IFFT2, FFTSHIFT, IFFTSHIFT

% % real data only
% if ~isreal(A) || ~isreal(B)
%     error(generatemsgid('InvalidInType'), 'Only real data are allowed.');
% end

% find the region that can cover both A and B
%   size of an image is [nrows (y), ncols (x)]
sz = max(size(A), size(B));

% Since cross-correlation is essentially a convolution, while convolution 
% can be implemented as element-wise multiplication in the reciprocal 
% space, we simply pad the input images A, B to enough size and perform an
% FFT/IFFT, viola!
f1 = fftshift(fft2(ifftshift(A), sz(1), sz(2)));
f2 = fftshift(fft2(ifftshift(B), sz(1), sz(2)));
fx = f1 .* f2;
% C = fftshift(ifft2(ifftshift(fx), 'symmetric'));
C = fftshift(ifft2(ifftshift(fx)));

end
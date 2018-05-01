function K = gaussf2(ksz, sig)
%GAUSSF2 2D Gaussian fucntion
%   K = GAUSSF2(KSZ, SIG) returns a rotationally symmetrica Gaussian
%   lowpass filter of size KSZ with standard deviation SIG (positive). The
%   default SIG is 1.

if numel(ksz) > 1 || ksz < 0
    error(generatemsgid('TooManyArguments'), ...
          'Kernel size only accept a positive scalar.');
end

if nargin < 2
    sig = 1;
end

r = (ksz-1) / 2;
[xv, yv] = meshgrid(-r:1:r, -r:1:r);

a = -(xv.*xv + yv.*yv) / (2*sig*sig);
K = exp(a);

K(K < eps*max(K(:))) = 0;
s = sum(K(:));
if s ~= 0
    K = K/s;
end

end

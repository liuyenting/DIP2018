clearvars; close all;

fn = fullfile('data', 'sample2.raw');
sz = [512, 512];

I2 = imread(fn, sz, 'gray');

dtype = class(I2);
M = intmax(dtype);
I2 = double(I2);

%% Denoise
figure('Name', 'Problem 1(b)', 'NumberTitle', 'off');
subplot(1, 4, 1);
imshow(I2, []);
title('Before');
set(gca, 'FontSize', 14);

FI2 = fftshift(fft2(I2));

subplot(1, 4, 2);
imshow(log(abs(FI2)), []);
title('log(|F(I_2)|)');
set(gca, 'FontSize', 14);

X = fxcorr2(abs(FI2), abs(FI2));
X = log(X);

%%%

sz = size(X);

ksz = 33;
r = ceil((ksz-1)/2);

J = zeros(sz, 'double');

% pad the input with respect to the kernel size
P = padarray(X, r, 'zero');

% convolve the data naively
for j = 1:sz(2)
    for i = 1:sz(1)
        % Simplify from 
        %   (j+r(1) - r(1) + is_even(1), j+r(1)+r(1)) -> )
        % to
        %   ((j + is_even(1), j+2*r(1))
        T = P(j:j+2*r, i:i+2*r);
        
        [~, ind] = max(T(:));
        [y, x] = ind2sub([ksz, ksz], ind);
        
        J(j, i) = y == r+1 & x == r+1;
    end
end

% find peaks
[y, x] = find(J);
% filter out peaks out of Nyquist limit and DC component
rlim0 = 16;
rlim1 = 128;
r = (x-256).^2 + (y-256).^2;
flag = r < rlim1.^2 & r > rlim0.^2;
x = x(flag);
y = y(flag);

% generate filter mask
M = zeros(sz);
mr = 2;
[xv, yv] = meshgrid(1:512, 1:512); 
for p = [x, y].'
    r = (xv-p(1)).^2 + (yv-p(2)).^2;
    M = M | r <= mr.^2;
end

subplot(1, 4, 3);
imshow(M, []);
title('Mask');
set(gca, 'FontSize', 14);

% filter the frequency domain
FI2(M) = 0;

If = ifft2(fftshift(FI2));
subplot(1, 4, 4);
imshow(If, []);
title('After');
set(gca, 'FontSize', 14);

%% Edges
figure('Name', 'Robert Filter', 'NumberTitle', 'off');
subplot(2, 2, 1);
imshow(I2, []);
title('I_2');
set(gca, 'FontSize', 14);

I2x = imconv2(I2, [1, 0; 0, -1]);
I2y = imconv2(I2, [0, 1; -1, 0]);

I2xy = sqrt(I2x.^2 + I2y.^2);

Iedge = I2xy > mean(I2xy(:));

subplot(2, 2, 3);
imshow(Iedge);
title('I_2 Edges');
set(gca, 'FontSize', 14);

subplot(2, 2, 2);
imshow(If, []);
title('I_F');
set(gca, 'FontSize', 14);

Ifx = imconv2(If, [1, 0; 0, -1]);
Ify = imconv2(If, [0, 1; -1, 0]);

Ifxy = sqrt(Ifx.^2 + Ify.^2);

Iedge = Ifxy > mean(Ifxy(:));

subplot(2, 2, 4);
imshow(Iedge);
title('I_F Edges');
set(gca, 'FontSize', 14);
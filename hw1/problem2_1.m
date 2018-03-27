clearvars; close all;

fn = fullfile('data', 'sample3.raw');
sz = [256, 256];

I3 = imread(fn, sz, 'gray');

figure('Name', 'Source', 'NumberTitle', 'off');
imshow(I3);
title('I_3');

dtype = class(I3);
M = intmax(dtype);
I3 = double(I3);

%% Image with Gaussian noise
sigma1 = 16;
G1 = sigma1*randn(sz) + I3;
G1 = cast(floor(G1), dtype);

figure('Name', 'Gaussian Noise', 'NumberTitle', 'off');
subplot(1, 2, 1);
imshow(G1);
title('G_1');
set(gca, 'FontSize', 14);

sigma2 = 32;
G2 = sigma2*randn(sz) + I3;
G2 = cast(floor(G2), dtype);

subplot(1, 2, 2);
imshow(G2);
title('G_2');
set(gca, 'FontSize', 14);

%% Image with salt-n-pepper noise
t1 = 0.01;
R1 = rand(sz);
S1 = I3;
S1(R1 < t1) = 0;
S1(R1 > 1-t1) = M;
S1 = cast(floor(S1), dtype);

figure('Name', 'Salt-n-Pepper Noise', 'NumberTitle', 'off');
subplot(1, 2, 1);
imshow(S1);
title('S_1');
set(gca, 'FontSize', 14);

t2 = 0.1;
R2 = rand(sz);
S2 = I3;
S2(R2 < t2) = 0;
S2(R2 > 1-t2) = M;
S2 = cast(floor(S2), dtype);

subplot(1, 2, 2);
imshow(S2);
title('S_2');
set(gca, 'FontSize', 14);

%% Low-pass filter
Rg = lpf(G1, 7);

figure('Name', 'Filtered Result', 'NumberTitle', 'off');
subplot(1, 2, 1);
imshow(Rg);
title('R_G');
set(gca, 'FontSize', 14);

%% Median filter
Rs = medfilter(S1, 3);

subplot(1, 2, 2);
imshow(Rs);
title('R_S');
set(gca, 'FontSize', 14);

%% PSNR
I3 = cast(I3, dtype);

PSNRg = psnr(Rg, I3)
PSNRs = psnr(Rs, I3)


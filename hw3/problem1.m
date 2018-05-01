clearvars; close all;

fn = fullfile('data', 'sample1.raw');
sz = [256, 256];

I1 = imread(fn, sz, 'gray');

% binarize
I1 = I1 > 0;



%% Boundary extraction
SE = strel('square', 3);
Ie = imerode(I1, SE);
B = I1 & ~Ie;

figure('Name', 'Boundary Extraction', 'NumberTitle', 'off');
subplot(1, 2, 1);
imshow(I1);
title('I_1');
set(gca, 'FontSize', 14);

subplot(1, 2, 2);
imshow(B);
title('B');
set(gca, 'FontSize', 14);

%imwrite(B, 'doc/images/B_m7.png');

%% Count object

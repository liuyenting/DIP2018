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
[L, n] = bwlabel(I1);

figure('Name', 'Labeling', 'NumberTitle', 'off');
subplot(1, 2, 1);
imshow(I1);
title('I_1');
set(gca, 'FontSize', 14);

ax = subplot(1, 2, 2);
imshow(L, []);
title(['Labeled, n=', num2str(n)]);
c = jet(n+1);
c(1, :) = [0, 0, 0]; % set background to black
colormap(ax, c);
set(gca, 'FontSize', 14);

% convert to colored version
%imwrite(ind2rgb(L, c), 'doc/images/L.png');

%% Skeletonizing
S = bwskel(I1);

figure('Name', 'Skeletonizing', 'NumberTitle', 'off');
subplot(1, 2, 1);
imshow(I1);
title('I_1');
set(gca, 'FontSize', 14);

subplot(1, 2, 2);
imshow(S);
title('S');
set(gca, 'FontSize', 14);

clearvars; close all;

fn = fullfile('data', 'sample1.raw');
sz = [512, 512];

I1 = imread(fn, sz, 'gray');

%% 1st order edge detection
%% Robert
figure('Name', 'Robert Filter', 'NumberTitle', 'off');
subplot(1, 4, 1);
imshow(I1);
title('I_1');
set(gca, 'FontSize', 14);

I1x = imconv2(I1, [1, 0; 0, -1]);
I1y = imconv2(I1, [0, 1; -1, 0]);

subplot(1, 4, 2);
imshow(I1x, []);
title('I_{1x}');
set(gca, 'FontSize', 14);

subplot(1, 4, 3);
imshow(I1y, []);
title('I_{1y}');
set(gca, 'FontSize', 14);

I1xy = sqrt(I1x.^2 + I1y.^2);

subplot(1, 4, 4);
imshow(I1xy, []);
title('I_{1xy}');
set(gca, 'FontSize', 14);

% [H, marks] = histogram(I1xy);
% figure('Name', 'Histogram', 'NumberTitle', 'off');
% bar(marks, H, 'k');
% ylabel('Counts');
% set(gca, 'FontSize', 14);


%% Prewitt
figure('Name', 'Prewitt Filter', 'NumberTitle', 'off');
subplot(1, 4, 1);
imshow(I1);
title('I_1');
set(gca, 'FontSize', 14);

I1x = imconv2(I1, [-1, 0, 1; -1, 0, 1; -1, 0, 1]);
I1y = imconv2(I1, [-1, -1, -1; 0, 0, 0; 1, 1, 1]);

subplot(1, 4, 2);
imshow(I1x, []);
title('I_{1x}');
set(gca, 'FontSize', 14);

subplot(1, 4, 3);
imshow(I1y, []);
title('I_{1y}');
set(gca, 'FontSize', 14);

I1xy = sqrt(I1x.^2 + I1y.^2);

subplot(1, 4, 4);
imshow(I1xy, []);
title('I_{1xy}');
set(gca, 'FontSize', 14);

%% Sobel
figure('Name', 'Sobel Filter', 'NumberTitle', 'off');
subplot(1, 4, 1);
imshow(I1);
title('I_1');
set(gca, 'FontSize', 14);

I1x = imconv2(I1, [1, 0, -1; 2, 0, -2; 1, 0, -1]);
I1y = imconv2(I1, [1, 2, 1; 0, 0, 0; -1, -2, -1]);

subplot(1, 4, 2);
imshow(I1x, []);
title('I_{1x}');
set(gca, 'FontSize', 14);

subplot(1, 4, 3);
imshow(I1y, []);
title('I_{1y}');
set(gca, 'FontSize', 14);

I1xy = sqrt(I1x.^2 + I1y.^2);

subplot(1, 4, 4);
imshow(I1xy, []);
title('I_{1xy}');
set(gca, 'FontSize', 14);

%% 2nd order edge detection

%% Canny edge detection
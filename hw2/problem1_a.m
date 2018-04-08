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

Iedge = I1xy > mean(I1xy(:))+2*std(I1xy(:));

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

Iedge = I1xy > mean(I1xy(:))+2*std(I1xy(:));

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

Iedge = I1xy > mean(I1xy(:))+2*std(I1xy(:));

%% 2nd order edge detection
%% Laplacian of Gaussian (LOG)
figure('Name', 'LoG', 'NumberTitle', 'off');
subplot(1, 4, 1);
imshow(I1, []);
title('I_1');
set(gca, 'FontSize', 14);

K = gaussf2(5);
Ig = imconv2(I1, K);

subplot(1, 4, 2);
imshow(Ig, []);
title('LPF(I_1)');
set(gca, 'FontSize', 14);

Ilog = imconv2(Ig, [0, 1, 0; 1, -4, 1; 0, 1, 0]);

subplot(1, 4, 3);
imshow(Ilog, []);
title('LoG(I_1)');
set(gca, 'FontSize', 14);

% [H, marks] = histogram(Ilog);
% figure('Name', 'Histogram', 'NumberTitle', 'off');
% bar(marks, H, 'k');
% ylabel('Counts');
% set(gca, 'FontSize', 14);

m = min(Ilog(:));
M = max(Ilog(:));
p = 0.4;
lo = (M-m)*(.5-abs(m)/(abs(M)+abs(m))*p) + m;
hi = (M-m)*(.5+abs(M)/(abs(M)+abs(m))*p) + m;

Iedge = Ilog < lo | Ilog > hi;

subplot(1, 4, 4);
imshow(Iedge, []);
title('Edge Map');
set(gca, 'FontSize', 14);

%% Difference of Gaussians (DOG)
K1 = gaussf2(25, 2);
K2 = gaussf2(25, 5);

figure('Name', 'Kernel', 'NumberTitle', 'off');

K = K2-K1;

figure('Name', 'DoG', 'NumberTitle', 'off');
subplot(1, 3, 1);
imshow(I1, []);
title('I_1');
set(gca, 'FontSize', 14);

Idog = imconv2(I1, K);

subplot(1, 3, 2);
imshow(Idog, []);
title('DoG(I_1)');
set(gca, 'FontSize', 14);

m = min(Idog(:));
M = max(Idog(:));
p = 0.4;
lo = (M-m)*(.5-abs(m)/(abs(M)+abs(m))*p) + m;
hi = (M-m)*(.5+abs(M)/(abs(M)+abs(m))*p) + m;

Iedge = Idog < lo | Idog > hi;

subplot(1, 3, 3);
imshow(Iedge, []);
title('Edge Map');
set(gca, 'FontSize', 14);

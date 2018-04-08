clearvars; close all;

%fn = fullfile('data', 'sample4.raw');
fn = fullfile('data', 'sample5.raw');
sz = [512, 512];

I = imread(fn, sz, 'gray');

%% Identify background
[Jlo, Blo] = bkgsub(I, 15);
[Jhi, Bhi] = bkgsub(I, 60);

figure('Name', 'Background', 'NumberTitle', 'off');
subplot(1, 3, 1);
imshow(Blo, []);
title('lo');
set(gca, 'FontSize', 14);

subplot(1, 3, 2);
imshow(Bhi, []);
title('hi');
set(gca, 'FontSize', 14);

subplot(1, 3, 3);
imshow(abs(Bhi-Blo), []);
title('Difference');
set(gca, 'FontSize', 14);

M = abs(Bhi-Blo);
M = M > mean(M(:));

figure('Name', 'Final Background', 'NumberTitle', 'off');

subplot(1, 3, 1);
imshow(M, []);
title('Mask');
set(gca, 'FontSize', 14);

Blo(M) = -255;
subplot(1, 3, 2);
imshow(Blo, []);
title('B_{lo}');
set(gca, 'FontSize', 14);

Bhi(M) = -255;
subplot(1, 3, 3);
imshow(Bhi, []);
title('B_{hi}');
set(gca, 'FontSize', 14);

% %% Subtract background
% figure('Name', 'Result', 'NumberTitle', 'off');
% subplot(1, 2, 1);
% imshow(Jhi, []);
% title('J_{hi}');
% set(gca, 'FontSize', 14);
% 
% Ja = Jhi/max(Jhi(:)) * 255;
% Ja = uint8(Ja);
% 
% Ja = histeq(Ja, 'limited', 65, 2);
% subplot(1, 2, 2);
% imshow(Ja, []);
% title('J_{a}');
% set(gca, 'FontSize', 14);
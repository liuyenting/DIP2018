clearvars; close all;

fn = fullfile('data', 'sample2.raw');
sz = [256, 256];

I2 = imread(fn, sz, 'gray');

figure('Name', 'Source', 'NumberTitle', 'off');
imshow(I2);
title('I_2');

%% Decrease the brightness
D = I2 / 3;

%% Histogram of I2 and D
[I2h, marks] = histogram(I2);
Dh = histogram(D);

figure('Name', 'Histograms before equalization', 'NumberTitle', 'off');
subplot(2, 1, 1);
bar(marks, I2h, 'k');
title('I_2');
ylabel('Counts');
set(gca, 'FontSize', 14);

subplot(2, 1, 2);
bar(marks, Dh, 'k');
title('D');
ylabel('Counts');
xlabel('Intensity');
set(gca, 'FontSize', 14);

%% Histogram equalization
H = histeq(D);

%% Local histogram equalization
L = histeq(D, 'adaptive', 15);

%% H/L comparison
[Hh, marks] = histogram(H);
Lh = histogram(L);

figure('Name', 'Equalization Results', 'NumberTitle', 'off');
subplot(1, 3, 1);
imshow(D);
title('D');
set(gca, 'FontSize', 14);

subplot(1, 3, 2);
imshow(H);
title('H');
set(gca, 'FontSize', 14);

subplot(1, 3, 3);
imshow(L);
title('L');
set(gca, 'FontSize', 14);

figure('Name', 'Histograms after equalization', 'NumberTitle', 'off');
subplot(2, 1, 1);
bar(marks, Hh, 'k');
title('Global');
ylabel('Counts');
set(gca, 'FontSize', 14);

subplot(2, 1, 2);
bar(marks, Lh, 'k');
title('Local');
ylabel('Counts');
xlabel('Intensity');
set(gca, 'FontSize', 14);

%% Transformations
a = 10;
Dlog = inttr(D, @(x) log2(1+a*x));

figure('Name', 'Transformation Results', 'NumberTitle', 'off');
subplot(1, 3, 1);
imshow(Dlog);
title('log_2 (1+ax), a=5');
set(gca, 'FontSize', 14);

Dinvlog = inttr(D, @(x) 1./log2(1+a*x));

subplot(1, 3, 2);
imshow(Dinvlog);
title('(log_2 (1+ax))^{-1}, a=5');
set(gca, 'FontSize', 14);

p = 3;
Dpow = inttr(D, @(x) x.^p);

subplot(1, 3, 3);
imshow(Dpow);
title('x^p, p=3');
set(gca, 'FontSize', 14);

[H, marks] = histogram(Dpow);
figure('Name', 'Plotter', 'NumberTitle', 'off', 'Position', [0, 0, 500, 200]);
bar(marks, H, 'k');
ylabel('Counts');
xlabel('Intensity');
C = cumsum(H);
C = C / numel(I2);
yyaxis right
plot(marks, C, '-r', 'LineWidth', 2);
ylabel('Fraction', 'Color', 'r');
set(gca, 'YColor', 'r');
set(gca, 'FontSize', 14);
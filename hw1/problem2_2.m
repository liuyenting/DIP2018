clearvars; close all;

fn = fullfile('data', 'sample4.raw');
sz = [256, 256];

I4 = imread(fn, sz, 'gray');

figure('Name', 'Problem 2-2', 'NumberTitle', 'off');
subplot(1, 2, 1);
imshow(I4);
title('Before');
set(gca, 'FontSize', 14);

dtype = class(I4);
M = intmax(dtype);
I4 = double(I4);

%% Smooth
J = lpf(I4, 5);
J = cast(floor(J), dtype);

subplot(1, 2, 2);
imshow(J);
title('After');
set(gca, 'FontSize', 14);
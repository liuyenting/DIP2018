clearvars; close all;

fn = fullfile('data', 'sample3.raw');
sz = [512, 512];

I3 = imread(fn, sz, 'gray');

dtype = class(I3);
M = intmax(dtype);
I3 = double(I3);

%% Edge crispening
figure('Name', 'Unsharp Filter', 'NumberTitle', 'off');
subplot(1, 3, 1);
imshow(I3, []);
title('Original');
set(gca, 'FontSize', 14);

K = gaussf2(15, 100);
Is = imconv2(I3, K);

subplot(1, 3, 2);
imshow(Is, []);
title('Smooth');
set(gca, 'FontSize', 14);

Ic = I3 - Is;

subplot(1, 3, 3);
imshow(Ic, []);
title('Unsharped');
set(gca, 'FontSize', 14);

Ic = Ic / max(abs(Ic(:)));
Ic = Ic + 1;

%% Warping
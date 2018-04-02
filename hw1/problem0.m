clearvars; close all;

fn = fullfile('data', 'sample1.raw');
sz = [256, 256];

I1 = imread(fn, sz, 'rgb');

figure('Name', 'Problem 0', 'NumberTitle', 'off');
subplot(1, 3, 1);
imshow(I1);
title('Original');

%% Convert to grayscale
I1 = reshape(I1, prod(sz), []);

I1 = double(I1);
I1g = I1 * [.2126, .7152, .0722].';
I1g = reshape(I1g, sz);
I1g = uint8(round(I1g));


subplot(1, 3, 2);
imshow(I1g);
title('Grayscale');

%% Diagonal flipping
ind = 1:numel(size(I1));
ind([1, 2]) = ind([2, 1]);
B = permute(I1g, ind);

subplot(1, 3, 3);
imshow(B);
title('Diagonal Flipping');
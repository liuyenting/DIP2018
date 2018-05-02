clearvars; close all;

fn = fullfile('data', 'sample2.raw');
sz = [512, 512];

I2 = imread(fn, sz, 'gray');

%% Segmentation
%K = law(I2);

%%
% ax = figure();
% imagesc(K);
% c = jet(3+1);
% c(1, :) = [0, 0, 0]; % set background to black
% colormap(ax, c);

%imwrite(ind2rgb(K, c), 'doc/images/K.png');

%% Texture synthesis
%p = I2(350:512, 250:512);
%p = I2(1:250, 300:500);
p = I2(1:200, 1:250);

h = figure('Name', 'Synthesis', 'NumberTitle', 'off');
subplot(1, 3, 1);
imagesc(I2);
axis image;
title('I_2');

subplot(1, 3, 2);
imagesc(p);
axis image;
title('patch');

drawnow;

Ip = texturesynth(double(p), [128, 128], 4);

figure(h);

subplot(1, 3, 3);
imagesc(Ip);
axis image;
title('I_p');

%%
imwrite(uint8(Ip), 'doc/images/tex1.png');

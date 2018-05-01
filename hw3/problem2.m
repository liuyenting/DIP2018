clearvars; close all;

fn = fullfile('data', 'sample2.raw');
sz = [512, 512];

I2 = imread(fn, sz, 'gray');

%% Segmentation
K = law(I2);

%%
figure();
imagesc(K);
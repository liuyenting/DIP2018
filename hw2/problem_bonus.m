clearvars; close all;

fn = fullfile('data', 'sample4.raw');
sz = [512, 512];

I = imread(fn, sz, 'gray');

%% Background subtraction
J = bkgsub(I, 30);

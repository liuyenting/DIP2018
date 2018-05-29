clearvars; close all;

fn = fullfile('data', 'TrainingSet.raw');
sz = [450, 248];

I = imread(fn, sz, 'gray');

%% Black-on-white to white-on-black
I = 255-I;

%% Character splits
% number of characters per sides
nch = [14, 5];
% character average size
chsz = floor(sz./nch);

% margins
msz = [5, 7];

% cut points
x = linspace(1+msz(1), sz(1)+1-msz(1), nch(1)+1); x = floor(x);
y = linspace(1+msz(2), sz(2)+1-msz(2), nch(2)+1); y = floor(y);

chkey = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*';
chkey = num2cell(chkey);

chval = cell([1, prod(nch)]);
for iy = 1:nch(2)
    for ix = 1:nch(1)
        chval{(iy-1)*nch(1) + ix} = I(y(iy):y(iy+1)-1, x(ix):x(ix+1)-1);
    end
end

%% Resize
% size (square) of the result
tsz = 32;

for i = 1:numel(chkey)
    chval{i} = uniresmpl(chval{i}, [tsz, tsz]);
end

figure('Name', 'Character Maps', 'NumberTitle', 'off'); 
for iy = 1:nch(2)
    for ix = 1:nch(1)
        i = (iy-1)*nch(1) + ix;
        subplot(nch(2), nch(1), i);
        imagesc(chval{i});
        axis image;
        title(chkey{i});
    end
end

%% Projection sum
for i = 1:numel(chkey)
    chval{i} = [sum(chval{i}, 1); sum(chval{i}, 2).'];
end

%% Save features
save('features.mat', 'chkey', 'chval');
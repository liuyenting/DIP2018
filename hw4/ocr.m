clearvars; close all;

fn = fullfile('data', 'sample2.raw');
sz = [390, 125];

I = imread(fn, sz, 'gray');

%% Binarize
thr = (max(I(:)) - min(I(:))) / 2;
% black-on-white
I = I < thr; 

%% (Optional) Filter
J = medfilt2(I, 3);

figure('Name', 'Filter', 'NumberTitle', 'off'); 
subplot(1, 2, 1); imagesc(I); axis image; title('Before');
subplot(1, 2, 2); imagesc(J); axis image; title('After');

I = J;

figure; imagesc(I); axis image;

%% Split characters
J = imdilate(I, ones(7, 7));
[J, nch] = bwlabel(J, 8, 0);
% ignore dilated regions
J(~I) = 0;

figure; imagesc(J); axis image;

% crop
ch = repmat(struct('image', {}, 'xpos', {}), 1, nch);
for c = 1:nch
    % find range 
    s.image = J == c;
    [y, x] = find(s.image);
    x_min = min(x); x_max = max(x);
    
    % crop to range
    s.image = s.image(min(y):max(y), x_min:x_max);
    
    % find horizontal position
    s.xpos = (x_min+x_max)/2;
    
    ch(c) = s;
end

% sort character position by horizontal position
[~, ind] = sort([ch.xpos]);
ch = ch(ind);

%% Resize
tsz = 32;
for c = 1:nch
    ch(c).image = uniresmpl(ch(c).image, [tsz, tsz]);
end

%% Generate features
load('features.mat');
nf = numel(chval);

% iterate over characters
for c = 1:nch
    temp = ch(c).image;
    
    xs = cumsum(sum(temp, 2).' + 1); 
    xs = (xs-min(xs)) / (max(xs)-min(xs));
    ys = cumsum(sum(temp, 1) + 1); 
    ys = (ys-min(ys)) / (max(ys)-min(ys));  
    
    v = interp1(xs, ys, linspace(0, 1, tsz));
    
    r_m = +Inf; ich = -1;
    rs = zeros(1, nf);
    for i = 1:nf
        r = abs(chval{i} - v);
        r = sum(r(:));
        
        if r < r_m
            r_m = r;
            ich = i;
        end
        
        rs(i) = r;
    end
    
    ch(c).df = rs;
    ch(c).result = chkey(ich);
end

figure('Name', 'Result', 'NumberTitle', 'off'); 
for c = 1:nch
    subplot(1, nch, c);
    imagesc(ch(c).image);
    axis image;
    title(ch(c).result);
end


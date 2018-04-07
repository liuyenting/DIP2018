clearvars; close all;

fn = fullfile('data', 'sample1.raw');
sz = [512, 512];

I1 = imread(fn, sz, 'gray');

I1 = double(I1);

figure('Name', 'Robert Filter', 'NumberTitle', 'off');
subplot(1, 5, 1);
imshow(I1, []);
title('Step 0');
set(gca, 'FontSize', 14);

%% Noise reduction 
K = gaussf2(7, 3);
I1_1 = imconv2(I1, K);

subplot(1, 5, 2);
imshow(I1_1, []);
title('Step 1');
set(gca, 'FontSize', 14);

%% Gradient magnitude and orientation
I1_2x = imconv2(I1_1, [1, 0, -1; 2, 0, -2; 1, 0, -1]);
I1_2y = imconv2(I1_1, [1, 2, 1; 0, 0, 0; -1, -2, -1]);

I1_2xy = sqrt(I1_2x.^2 + I1_2y.^2);
I1_2th = atan2(I1_2y, I1_2x);
% to degree, easy to think...
I1_2th = I1_2th * 180/pi;
% wrap around
I1_2th(I1_2th < 0) = I1_2th(I1_2th < 0) + 360;
% avoid tiny numbers
I1_2th(I1_2th < eps*max(I1_2th(:))) = 0;

subplot(1, 5, 3);
imshow(I1_2xy, []);
title('Step 2');
set(gca, 'FontSize', 14);

%% Non-maximal suppression
% fix direction to 0, 45, 90 or 135 degrees
I1_2th((I1_2th >= 0 & I1_2th < 22.5) | ...
       (I1_2th >= 157.5 & I1_2th < 202.5) | ...
       (I1_2th >= 337.5 & I1_2th <= 360)) = 0;
I1_2th((I1_2th >= 22.5 & I1_2th < 67.5) | ...
       (I1_2th >= 202.5 & I1_2th < 247.5)) = 45; 
I1_2th((I1_2th >= 67.5 & I1_2th < 112.5) | ...
       (I1_2th >= 247.5 & I1_2th < 292.5)) = 90;
I1_2th((I1_2th >= 112.5 & I1_2th < 157.5) | ...
       (I1_2th >= 292.5 & I1_2th < 337.5)) = 135; 
   
I1_3 = zeros(size(I1));
for y = 2:sz(1)-1
    for x = 2:sz(2)-1
        if I1_2th(y, x) == 0
            I1_3(y, x) = I1_2xy(y, x) == max([I1_2xy(y, x), I1_2xy(y, x+1), I1_2xy(y, x-1)]);
        elseif I1_2th(y, x) == 45
            I1_3(y, x) = I1_2xy(y, x) == max([I1_2xy(y, x), I1_2xy(y+1, x-1), I1_2xy(y-1, x+1)]);
        elseif I1_2th(y, x) == 90
            I1_3(y, x) = I1_2xy(y, x) == max([I1_2xy(y, x), I1_2xy(y+1, x), I1_2xy(y-1, x)]);
        elseif I1_2th(y, x) == 135
            I1_3(y, x) = I1_2xy(y, x) == max([I1_2xy(y, x), I1_2xy(y+1, x+1), I1_2xy(y-1, x-1)]);
        else
            error(generatemsgid('CodeError'), 'This shouldn''t happen.');
        end
    end
end
I1_3 = I1_3 .* I1_2xy;

subplot(1, 5, 4);
imshow(I1_3, []);
title('Step 3');
set(gca, 'FontSize', 14);

%% Hysteretic thresholding


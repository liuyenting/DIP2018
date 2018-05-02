function J = texturesynth(I, outsz, wsz)
%TEXTURESYNTH Synthesizes texture to produce an output image of any size.
%   J = TEXTURESYNTH(I, OUTSZ, WSZ) generates syntehsized texture J of size
%   OUTSZ using provided sample texture I. Sampling window for the n-gram
%   schema is determined by WSZ.
%
%   Reference: 
%   - Texture synthesis by non-parametric sampling
%     10.1109/ICCV.1999.790383
%   - Reference implementation from 'asteroidhouse/texturesynth'
%     https://github.com/asteroidhouse/texturesynth

nu = outsz(1); 
nv = outsz(2);

if mod(wsz, 2) == 0
    wsz = wsz + 1;
end

r = floor(wsz / 2);

% side length of the initial seed 
ssz = 3;

[ny, nx] = size(I);

% create the initial image and map of filled pixels
[J, M] = textureseed(I, ssz, outsz);

% pad half-window size for convolution later
PJ = padarray(J, r, 'zero');
PM = padarray(M, r, 'zero');

error_threshold = 0.1;
max_error_threshold = 0.3;

% candidate patch
candidates = im2colslide(I, [wsz wsz]);

%sigma = 6.4;
%gaussian = fspecial('gaussian', [wsz wsz], wsz / sigma);
% DEV locked, for simplicity
gaussian = [
    .0013, .0167, .0167, .0013;
    .0167, .2154, .2154, .0167;
    .0167, .2154, .2154, .0167;
    .0013, .0167, .0167, .0013
];
gaussian_vec = reshape(gaussian, [], 1);

% DEV temporary viewer
figure('Name', 'Temporary', 'NumberTitle', 'off');
n = 0;

% loop until no unfilled pixel
while ~all(all(M))
    found_match = false;
    
    % list of all unfilled pixels
    unfilled_pixels = unfilledpx(M);
    
    for pixel = unfilled_pixels
        [pxy, pxx] = ind2sub(size(M), pixel);
        
        % neighbors around current pixel and mask showing which neighbors
        % are filled
        [neighbourhood, mask] = neighbors(PJ, PM, pxx, pxy, wsz);
        
        neighbourhood_vec = reshape(neighbourhood, [], 1);
        % Create a matrix where every column is the neighbourhood, and
        % there are as many columns as there are candidate patches.
        neighbourhood_rep = repmat(neighbourhood_vec, 1, size(candidates, 2));
        
        mask_vec = reshape(mask, [], 1);
        mask_vec = repmat(mask_vec, size(candidates, 3), 1);
        
        % sum of the valid gaussian elements
        weight = sum(mask_vec .* gaussian_vec);
        
        % normalized gaussian filter result
        gaussian_mask = ((gaussian_vec .* mask_vec) / weight)';
        
        % distance between current neighbor and all candidate patches
        D = gaussian_mask * ((candidates - neighbourhood_rep) .^ 2);
        
        m = min(D);
        min_threshold = m * (1 + error_threshold);
        % find all positions that is similar (less than threshold)
        pos = find(D <= min_threshold);
        
        % select a patch randomly from all patches with minimum distances
        random_col = randi(length(pos));
        selected_patch = pos(random_col);
        selected_error = D(selected_patch);
        
        if selected_error < max_error_threshold
           [matched_row, matched_col] = ind2sub([(ny-wsz+1) (nx-wsz+1)], selected_patch);
           
           matched_row = matched_row + r;
           matched_col = matched_col + r;
           
           % copy pixel in the middle of the matched patch to synthesis
           % location
           J(pxy, pxx, :) = I(matched_row, matched_col, :);
           
           % mark as filled and this iteration is dirty
           M(pxy, pxx) = 1;
           found_match = true;
        end

    end
    
    if mod(n, 10) == 0
        imagesc(J);
        axis image;
        drawnow;
    end
    n = n+1;
    
    % Update the interior of the padded images, to reflect the updated
    % pixel that was added (or not) to the output image in this iteration.
    PJ(r+1:r+nu, r+1:r+nv,:) = J;
    PM(r+1:r+nu, r+1:r+nv) = M;
    
    % If there was no match for any unfilled pixel, we need to make the
    % error threshold higher, or there will be no more progress.
    if ~found_match
        max_error_threshold = max_error_threshold * 1.1;
    end

end

end

function px = unfilledpx(M)
%UNFILLEDPX Indices of unfilled pixels in next layer.
%   PX = UNFILLEDPX(M) generates positions of unfilled pixels in the next
%   layer from a binary matrix M. 

SE = strel2('square', 3);

dilated_map = imdilate(M, SE);
diff_image = dilated_map - M;

px = find(diff_image)'; 

end

function [nei, mask] = neighbors(I, M, pxx, pxy, wsz)
%NEIGHBORS Neighbor pixels from a padded image.
%   [NEI, MASK] = NEIGHBORS(I, M, PXX, PXY, WSZ) provides region info NEI 
%   about specific pixel and their respective MASK from image I and its
%   filled-pixel map M. PXX and PXY denotes the coordinate of the pixel at
%   the center of the neighborhood, while WSZ is the side length of the
%   windows.

hsz = floor(wsz/2);

% offset for the border
pxx = pxx + hsz;
pxy = pxy + hsz;

nei = I(pxy-hsz:pxy+hsz, pxx-hsz:pxx+hsz, :);
mask = M(pxy-hsz:pxy+hsz, pxx-hsz:pxx+hsz, :);

end
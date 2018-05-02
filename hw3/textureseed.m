function [J, filled_map] = textureseed(I, ssz, outsz)
% Creates an image of size (output_rows x output_cols), which has in the
% center a random (seed_size x seed_size) patch taken from the original
% input image.
%
% Inputs:
%   I: the original image used as the basis for sampling pixels
%   ssz: the side length of the seed that will be copied from the
%              input_image and placed in the centre of the output_image
%   outsz: desired number of (rows, columns) for the output image
%
% Outputs:
%   J: an image of size (output_rows x output_cols) that is
%                 black, except for a seed in the centre
%   filled_map: a binary matrix that contains 0s, except in the centre,
%               where it has 1s corresponding to the seed pixels
% 
% The original_image is expected to have entries of type double
% The seed_size must be an odd integer that is less than or equal to 
% the minimum of the original_image width or height.

nv = outsz(1);
nu = outsz(2);

% Gets the dimensions of the input image
[ny, nx] = size(I);

% Computes a margin for the right side and bottom of the image, to ensure
% that the random number selected for the 
margin = ssz - 1;

rand_row = randi([1, ny - margin]);
rand_col = randi([1, nx - margin]);
seed_patch = I(rand_row:rand_row+margin, rand_col:rand_col+margin, :);

% Puts the seed patch in the centre of the output image.
J = zeros(outsz);
cu = floor(nv / 2);
cv = floor(nu / 2);
hsz = floor(ssz / 2);
J(cu-hsz:cu+hsz, cv-hsz:cv+hsz) = seed_patch;

% Makes the seed patch positions equal to 1 in the filled map.
filled_map = false(nv, nu);
filled_map(cu-hsz:cu+hsz, cv-hsz:cv+hsz) = 1;

end
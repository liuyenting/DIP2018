function J = uniresmpl(I, jsz)
%UNIRESMPL Uniformly resample provided image
%   Detailed explanation goes here

isz = size(I);
xv = linspace(1, isz(2), jsz(2));
yv = linspace(1, isz(1), jsz(1));

% generate output grid
[uv, vv] = meshgrid(xv, yv);

J = interp2(double(I), uv, vv); 

end


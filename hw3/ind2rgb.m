function J = ind2rgb(I, cm)
%IND2RGB Convert indexed image to RGB image.
%   RGB = IND2RGB(X,MAP) converts the matrix X and corresponding
%   colormap MAP to RGB (truecolor) format.

sz = size(I);

% colormap index starts from 1
I = I+1;

if max(I(:)) ~= size(cm, 1)
    error(generatemsgid('InsufficientIndex'), ...
          'Colormap cannot fully describe provided indexed image.');
end

% additional memory to avoid reshape later
r = zeros(sz);
r(:) = cm(I, 1);
g = zeros(sz);
g(:) = cm(I, 2);
b = zeros(sz);
b(:) = cm(I, 3);

J = cat(3, r, g, b);

end

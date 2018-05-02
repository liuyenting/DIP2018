function L = law(I)
%LAW Summary of this function goes here
%   Detailed explanation goes here

sz = size(I);

K = zeros([3, 3, 9]);
K(:, :, 1) = [1, 2, 1; 2, 4, 2; 1, 2, 1] / 36;
K(:, :, 2) = [1, 0, -1; 2, 0, -2; 1, 0, -1] / 12;
K(:, :, 3) = [-1, 2, -1; -2, 4, -2; -1, 2, -1] / 12;
K(:, :, 4) = [-1, -2, -1; 0, 0, 0; 1, 2, 1] / 12;
K(:, :, 5) = [1, 0, -1; 0, 0, 0; -1, 0, 1] / 4;
K(:, :, 6) = [-1, 2, -1; 0, 0, 0; 1, -2, 1] / 4;
K(:, :, 7) = [-1, -2, -1; 2, 4, 2; -1, -2, -1] / 12;
K(:, :, 8) = [-1, 0, 1; 2, 0, -2; -1, 0, 1] / 4;
K(:, :, 9) = [1, -2, 1; -2, 4, -2; 1, -2, 1] / 4;

M = zeros([sz, 9]);
for i = 1:9
    M(:, :, i) = imconv2(I, K(:, :, i));
end

figure('Name', 'M', 'NumberTitle', 'off');
for i = 1:9
    subplot(3, 3, i);
    imagesc(M(:, :, i));
end
drawnow;

w = 15;
T = zeros(size(M));
for i = 1:9
    T(:, :, i) = energy(M(:, :, i), w);
end

figure('Name', 'T', 'NumberTitle', 'off');
for i = 1:9
    subplot(3, 3, i);
    imagesc(T(:, :, i));
end
drawnow;

X = [];
for i = 1:9
    t = T(:, :, i);
    X = [X, t(:)];
end
X = X.';

[L, mu, E] = kmeans(X, 3);

L = reshape(L, size(I));

end

function T = energy(M, w)

r = (w-1)/2;

sz = size(M);
T = zeros(sz);

% zero-pad I
P = zeros(sz + w-1);
P(r+1:end-r, r+1:end-r) = M;

% convolve the data with equalization kernel naively
for j = 1:sz(2)
    for i = 1:sz(1)
        t = P(j:j+w-1, i:i+w-1).^2;
        T(j, i) = sum(t(:));
    end
end

end


function J = padarray(I, psz, mode)
%PADARRAY Extend the boundary.
%   TBA

nd = ndims(I);
if nd ~= 2
    error(generatemsgid('InvalidSize'), 'Only 2D array is supported.');
end

if nargin < 3
    mode = 'mirror';
end

% pad size
if isscalar(psz)
    psz = ones([1, nd]) * psz;
elseif numel(psz) ~= nd
    error(generatemsgid('InvalidSize'), ...
          'Pad size does not match data size.');
end

switch mode
    case 'mirror'
        J = mirrorpad(I, psz);
    case 'zero'
        J = zeropad(I, psz);
    otherwise
        error(generatemsgid('UnknownMode'), 'Unknown padding method.');
end

end

function J = zeropad(I, psz)

J = zeros(sz+2*psz, 'like', I);
J(psz(1)+1:end-psz(1), psz(2)+1:end-psz(2)) = I;

end

function J = mirrorpad(I, psz)

sz = size(I);
is_odd = mod(sz, 2);
J = zeros(sz+2*psz, 'like', I);

% fill the original region
J(psz(1)+1:end-psz(1), psz(2)+1:end-psz(2)) = I;

% vertical padding
F = flip(I, 1);
if is_odd(1)
    J(1:psz(1), psz(2)+1:end-psz(2)) = F(end-psz(1):end-1, :);
    J(end-psz(1)+1:end, psz(2)+1:end-psz(2)) = F(2:psz(1)+1, :);
else
    J(1:psz(1), psz(2)+1:end-psz(2)) = F(end-psz(1)+1:end, :);
    J(end-psz(1)+1:end, psz(2)+1:end-psz(2)) = F(1:psz(1), :);
end

% diagonal padding
F = flip(F, 2);
if is_odd(1)
    J(1:psz(1), 1:psz(2)) = F(end-psz(1):end-1, end-psz(2):end-1);
    J(1:psz(1), end-psz(2)+1:end) = F(end-psz(1):end-1, 2:psz(2)+1);
    J(end-psz(1)+1:end, 1:psz(2)) = F(2:psz(1)+1, end-psz(2):end-1);
    J(end-psz(1)+1:end, end-psz(2)+1:end) = F(2:psz(1)+1, 2:psz(2)+1);
else
    J(1:psz(1), 1:psz(2)) = F(end-psz(1)+1:end, end-psz(2)+1:end);
    J(1:psz(1), end-psz(2)+1:end) = F(end-psz(1)+1:end, 1:psz(2));
    J(end-psz(1)+1:end, 1:psz(2)) = F(1:psz(1), end-psz(2)+1:end);
    J(end-psz(1)+1:end, end-psz(2)+1:end) = F(1:psz(1), 1:psz(2));
end

% horizontal padding
F = flip(I, 2);
if is_odd(1)
    J(psz(1)+1:end-psz(1), 1:psz(2)) = F(:, end-psz(2):end-1);
    J(psz(1)+1:end-psz(1), end-psz(2)+1:end) = F(:, 2:psz(2)+1);
else
    J(psz(1)+1:end-psz(1), 1:psz(2)) = F(:, end-psz(2)+1:end);
    J(psz(1)+1:end-psz(1), end-psz(2)+1:end) = F(:, 1:psz(2));
end

end

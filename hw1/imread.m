function I = imread(filename, sz, type, tr)
%IMREAD Customized RAW format file reader.
%   TBA

% set default value
if nargin < 4
    tr = true;
end
if nargin < 3
    type = 'gray';
end

% determine number of channels
switch type
    case 'gray'
        nc = 1;
    case 'rgb'
        nc = 3;
    otherwise
        error(generatemsgid('InvalidType'), ...
              'Unknown data type, must be ''gray'' or ''rgb''.');
end
% actual shape
sz = [sz, nc];

disp(['Reading from ''', filename, '''']);
fd = fopen(filename, 'rb');
if (fd == -1)
    error(generatemsgid('InvalidFile'), 'Unable to open the file.');
end
[raster, bytes] = fread(fd, inf, '*uint8');
fclose(fd);

if bytes ~= prod(sz)
    warning(generatemsgid('SizeMismatch'), ...
            'Provided image size does not match total byte counts.');
end

% reshape to actual size
I = reshape(raster, sz);

% swap X/Y to deal with column/raw major
if tr
    ind = 1:numel(sz);
    ind([1, 2]) = ind([2, 1]);
    I = permute(I, ind);
end

end

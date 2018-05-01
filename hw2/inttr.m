function J = inttr(I, func)
%INTTR Intensity transform according to specified equations.
%   TBA

if ~isinteger(I)
    error(generatemsgid('InvalidType'), 'Only integer image is allowed.');
end
dtype = class(I);
m = double(intmin(dtype));
M = double(intmax(dtype));

Ih = histogram(I);
% sum(Ih) = 1
Ih = Ih / numel(I);

x = cumsum(Ih);
% re-mapped as unsigned data
J = (M-m) * func(x(I+1));
% integers only
J = floor(J);
% shift downward for signed data types 
J = J - m;

% use original data type
J = cast(J, dtype);

end

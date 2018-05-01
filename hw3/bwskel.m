function J = bwskel(I)
%BWSKEL Reduce all objects to lines in 2-D binary image.
%   Detailed explanation goes here

sz = size(I);

%
% 1st
%
M_LUT = [
    64, 16, 4, 1, ... % S1
    128, 32, 8, 2, ... % S2
    192, 96, 48, 24, 12, 6, 3, 129, ... % S3
    160, 40, 10, 130, ... %TK4
    193, 112, 28, 7, ... %STK4
    176, 161, 104, 194, 224, 56, 14 ,131, ... % ST5
    177, 108, ... % ST6
    240, 225, 120, 60, 15, 135, 195, ... % STK6
    241, 124, 31, 199, ... % STK7
    227, 248, 62, 143, ... % STK8
    243, 231, 252, 249, 124, 63, 159, 207, ... % STK9
    247, 253, 127, 223, ... % STK10
    251, 254, 191, 239 % K11
];
M_LUT = uint8(M_LUT);
%
% 1st
%


%
% 2nd
%
EQ_LUT = [
    1, 4, 64, 16, ... % spur
    2, 128, 8, 32, ... % 4-conn
    160, 40, 130, 10 % L
];
EQ_LUT = uint8(EQ_LUT);
OR_EQ_LUT = [
    31, 255; 241, 255; 199, 255; 124, 255; % corner
    84, 252; 213, 255; 117, 255; 93, 255; % tee
    17, 181; 68, 109; 17, 91; 68, 214 % diag
];
OR_EQ_LUT = uint8(OR_EQ_LUT);
OR_NOT_LUT = [
    184, 248; 42, 62; 138, 143; 162, 227 % vee
];
OR_NOT_LUT = uint8(OR_NOT_LUT);
%
% 2nd
%

figure();

J = zeros(sz);
firstrun = true;
while firstrun || ~isequal(I, J)
    if firstrun
        firstrun = false;
    end
    
    M = zeros(sz);
    for j = 2:sz(1)-1
        for i = 2:sz(2)-1
            if ~I(j, i)
                continue;
            end
            
            T = bi2de([I(j, i+1), I(j-1, i+1), I(j-1, i), I(j-1, i-1), ...
                       I(j, i-1), I(j+1, i-1), I(j+1, i), I(j+1, i+1)]);
            M(j, i) = ismember(T, M_LUT);
        end
    end

    P = zeros(sz);
    for j = 2:sz(1)-1
        for i = 2:sz(2)-1
            if ~M(j, i)
                continue;
            end
            
            T = bi2de([M(j, i+1), M(j-1, i+1), M(j-1, i), M(j-1, i-1), ...
                       M(j, i-1), M(j+1, i-1), M(j+1, i), M(j+1, i+1)]);
            T = uint8(T);
            
            if ismember(T, EQ_LUT)
                P(j, i) = 1;
            elseif any((bitor(T, OR_EQ_LUT(:, 1)) == OR_EQ_LUT(:, 2)) & (bitand(T, bitcmp(OR_EQ_LUT(:, 1))) == bitand(OR_EQ_LUT(:, 2), bitcmp(OR_EQ_LUT(:, 1)))))
                P(j, i) = 1;
            elseif any((bitor(T, OR_NOT_LUT(:, 1)) ~= OR_NOT_LUT(:, 2)) & (bitand(T, bitcmp(OR_NOT_LUT(:, 1))) == bitand(OR_NOT_LUT(:, 2), bitcmp(OR_NOT_LUT(:, 1)))))
                P(j, i) = 1;
            end
        end
    end
    
    J = I;
    I = I & (~M | P);
    
    subplot(1, 3, 1);
    imagesc(M);
    subplot(1, 3, 2);
    imagesc(P);
    subplot(1, 3, 3);
    imagesc(I);
    
    drawnow;
end

end

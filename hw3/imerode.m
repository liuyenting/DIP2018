function J = imerode(I, SE)
%IMERODE Erode image.
%   Detailed explanation goes here

sz = size(I);

ksz = size(SE);
r = ceil((ksz-1)/2);

P = zeros(sz + ksz-1, 'logical');
firstrun = true;
for j = 1:ksz(2)
    for i = 1:ksz(1)
        if ~SE(j, i)
            continue;
        end
        
        T = zeros(sz + ksz-1, 'logical');
        T(j:j+sz(2)-1, i:i+sz(1)-1) = I;
        
        if firstrun
            P = T;
            firstrun = false;
        else
            P = P & T;
        end
    end
end

J = P(r+1:r+sz(2), r+1:r+sz(1));

end


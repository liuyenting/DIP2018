function J = im2colslide(I, block)
%IM2COL Rearrange image blocks into columns.
%   B = IM2COL(A, [M N]) converts each sliding M-by-N
%   block of A into a column of B, with no zero padding. B has
%   M*N rows and will contain as many columns as there are M-by-N
%   neighborhoods in A. If the size of A is [MM NN], then the
%   size of B is (M*N)-by-((MM-M+1)*(NN-N+1). Each column of B
%   contains the neighborhoods of A reshaped as NHOOD(:), where
%   NHOOD is a matrix containing an M-by-N neighborhood of
%   A. IM2COL orders the columns of B so that they can be
%   reshaped to form a matrix in the normal way. For example,
%   suppose you use a function, such as SUM(B), that returns a
%   scalar for each column of B. You can directly store the
%   result in a matrix of size (MM-M+1)-by-(NN-N+1) using these
%   calls:
%
%        B = im2col(A,[M N]);
%        C = reshape(sum(B),MM-M+1,NN-N+1);
%   Reference: MATLAB, im2col

[ma, na] = size(I);
m = block(1); 
n = block(2);

% unable to slide when window itself is larger than sample image
if any([ma, na] < [m, n])
    J = zeros(m*n, 0);
    return
end

% Hankel indexing submatrix
mc = block(1); nc = ma-m+1; nn = na-n+1;
cidx = (0:mc-1)'; ridx = 1:nc;
% Hankel subscripts
t = cidx(:,ones(nc,1)) + ridx(ones(mc,1),:);
tt = zeros(mc*n,nc);
rows = 1:mc;
for i=0:n-1
    tt(i*mc+rows,:) = t+ma*i;
end
ttt = zeros(mc*n,nc*nn);
cols = 1:nc;
for j=0:nn-1
    ttt(:,j*nc+cols) = tt+ma*j;
end

% convert to column vector if I is a row vector
if ismatrix(I) && na > 1 && ma == 1
    I = I(:);
end
J = I(ttt);

end

function [label, mu, energy] = kmeans(X, k)
%KMEANS Perform kmeans clustering.
% Input:
%   X: d x n data matrix
%   m: initialization parameter
% Output:
%   label: 1 x n sample labels
%   mu: d x k center of clusters
%   energy: optimization target value
% Written by Mo Chen (sth4nth@gmail.com).
m = kseeds(X, k);
label = init(X, m);
n = numel(label);
idx = 1:n;
last = zeros(1,n);
while any(label ~= last)
    [~,~,last(:)] = unique(label);                  % remove empty clusters
    mu = X*normalize(sparse(idx,last,1),1);         % compute cluster centers 
    [val,label] = min(dot(mu,mu,1)'/2-mu'*X,[],1);  % assign sample labels
end
energy = dot(X(:),X(:),1)+2*sum(val);
end

function label = init(X, m)
[d,n] = size(X);
if numel(m) == 1                           % random initialization
    mu = X(:,randperm(n,m));
    [~,label] = min(dot(mu,mu,1)'/2-mu'*X,[],1); 
elseif all(size(m) == [1,n])               % init with labels
    label = m;
elseif size(m,1) == d                      % init with seeds (centers)
    [~,label] = min(dot(m,m,1)'/2-m'*X,[],1); 
end
end

function mu = kseeds(X, k)
% Perform kmeans++ seeding
% Input:
%   X: d x n data matrix
%   k: number of seeds
% Output:
%   label: 1 x n sample labels
%   mu: d x k seeds
%   energy: kmeans target value
% Written by Mo Chen (sth4nth@gmail.com).
n = size(X,2);
D = inf(1,n);
mu = X(:,ceil(n*rand));
for i = 2:k
    D = min(D,sum((X-mu(:,i-1)).^2,1));
    mu(:,i) = X(:,randp(D));
end
end

function i = randp(p)
% Sample a integer in [1:k] with given probability p
i = find(rand<cumsum(normalize(p)),1);
end

function Y = normalize(X, dim)
% Normalize the vectors to be summing to one
%   By default dim = 1 (columns).
% Written by Michael Chen (sth4nth@gmail.com).
if nargin == 1
    % Determine which dimension sum will use
    dim = find(size(X)~=1,1);
    if isempty(dim), dim = 1; end
end
Y = X./sum(X,dim);
end


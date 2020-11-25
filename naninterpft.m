function X = naninterpft(X)
% Interpolate over NaNs
% See INTERP1 for more info
X(isnan(X)) = interpft(find(~isnan(X)), X(~isnan(X)), find(isnan(X)));
return
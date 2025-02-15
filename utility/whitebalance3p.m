function WB = whitebalance3p(I)
    L = rgb2lin(I);
    mu = sum(sum(I)) / (size(I,1) * size(I,2));
    WB = lin2rgb(min(max(L .* reshape(mu(2) ./ mu, [1 1 3]), 0), 1));
end
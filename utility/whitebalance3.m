function WB = whitebalance3(I)
    I = rgb2lin(I);

    % Compute the mean intensity of each channel separately
    mu = sum(sum(I)) / (size(I,1) * size(I,2));
    
    % Normalize each channel by its mean
    WB = lin2rgb((I ./ reshape(mu,[1 1 3])) * (sum(mu) / 3));  % Scale each channel to maintain brightness
end
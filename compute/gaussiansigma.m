function [sigma_min, sigma_max] = gaussiansigma(N)
    sigma_min = (N-1)/5;
    sigma_max = (N+1)/5 - 0.05;
end
function WB = whitebalance(I)
    ac = sum(sum(I)) / (size(I,1) * size(I,2));
    WB = I .* (1/(2*ac));
end
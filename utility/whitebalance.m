function WB = whitebalance(I)
    ac = sum(sum(I)) / (size(I,1) * size(I,2));
    % WB = I .* (1/(2*ac));
    WB = min(max(I .* (1/(2*ac)),0),1);
end
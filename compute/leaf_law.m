function [spot,ripple,edge_ripple,edge_spot,edge_wave] = leaf_law(im)
    S5 = [-1 0 2 0 -1];
    R5 = [1 -4 6 -4 1];
    W5 = [-1 2 0 -2 1];
    L5 = [1 4 6 4 1];
    %E5 = [-1 -2 0 2 1];
    spot = im .* conv2(S5,S5,im,'same');
    ripple = im .* conv2(R5,R5,im,'same');
    edge_ripple = im .* (conv2(L5,R5,im,'same') + conv2(R5,L5,im,'same'));
    edge_spot = im .* (conv2(L5,S5,im,'same') + conv2(S5,L5,im,'same'));
    edge_wave = im .* (conv2(L5,W5,im,'same') + conv2(W5,L5,im,'same'));
end
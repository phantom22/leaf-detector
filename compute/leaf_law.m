function [spot,ripple,edge_ripple,edge_spot,edge_wave] = leaf_law(im)
    S5 = [-1 0 2 0 -1];
    R5 = [1 -4 6 -4 1];
    W5 = [-1 2 0 -2 1]; 
    E5 = [-1 -2 0 2 1];
    spot = conv2(S5,S5,im,'same').^2;
    ripple = conv2(R5,R5,im,'same').^2;
    edge_ripple = conv2(E5,R5,im,'same').^2 + conv2(R5,E5,im,'same').^2;
    edge_spot = conv2(E5,S5,im,'same').^2 + conv2(S5,E5,im,'same').^2;
    edge_wave = conv2(E5,W5,im,'same').^2 + conv2(W5,E5,im,'same').^2;
end
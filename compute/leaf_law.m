function L = leaf_law(im)
    L5 = [1 4 6 4 1];
    L = conv2(L5,L5,im,'same').^2;
end
function lap = mylaplacian(im)
    k = [-1 -1 -1; -1 8 -1; -1 -1 -1];
    lap = imfilter(im, k, 'symmetric','same');
end
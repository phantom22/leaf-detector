function lap = mylaplacian(im)
    k = [0 -1 0; -1 4 -1; 0 -1 0];
    lap = imfilter(im, k, 'symmetric','same');
end
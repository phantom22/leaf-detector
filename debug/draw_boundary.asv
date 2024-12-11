function draw_boundary(bw)
    bounds = bwboundaries(bw);
    b = bounds{1};
    c = round(regionprops(bw, double(bw), 'WeightedCentroid').WeightedCentroid);

    tmp = zeros(size(bw),'single');
    for i = 1:size(b, 1)
        tmp(b(i, 1), b(i, 2)) = 1; % Access each (row, column) pair
    end
    tmp(c(2),c(1)) = 1;
    imshow(tmp);
end
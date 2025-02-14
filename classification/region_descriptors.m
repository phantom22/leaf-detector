function d = region_descriptors(im, leaf_mask)
    if ~isa(im, 'single')
        im = im2single(im);
    end

    inv_mask = 1 - leaf_mask;
    L = bwlabel(inv_mask);

    s = regionprops(inv_mask, 'Area');

    [~, largestRegionIdx] = max([s.Area]);
    bg_mask = L == largestRegionIdx;

    leaf_mask = single(1 - bg_mask);

    %masked = im .* leaf_mask;
    %HSV = rgb2hsv(masked);

    s = regionprops(leaf_mask, 'MajorAxisLength', 'MinorAxisLength', ...
        'Area', 'Perimeter', 'Eccentricity', 'Solidity');

    % L5 = [1 4 6 4 1]; 
    % E5 = [-1 -2 0 2 1];
    % S5 = [-1 0 2 0 -1];
    % R5 = [1 -4 6 -4 1];

    d = zeros(13,1,'single');

    %area = nnz(gim);

    d(1:7) = py_hu_moments(leaf_mask);

    % extract_edges maybe should return the masks
    %[strong,weak,~] = extract_edges(HSV(:,:,3));

    %d(8) = sum(sum(strong)) / sum(sum(weak));

    d(8) = s.MajorAxisLength;
    d(9) = s.MinorAxisLength;
    d(10) = s.Area;
    d(11) = s.Perimeter;

    d(12) = s.Eccentricity;
    d(13) = s.Solidity;

    leaf_area = nnz(leaf_mask);
    d(8:11) = d(8:11) / sqrt(leaf_area);
end


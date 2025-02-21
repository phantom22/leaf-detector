function d = region_descriptors(im, leaf_mask)
    if ~isa(im, 'single')
        im = im2single(im);
    end

    inv_mask = 1 - leaf_mask;
    L = bwlabel(inv_mask);

    s = regionprops(inv_mask, 'Area');

    [~, largestRegionIdx] = max([s.Area]);
    bg_mask = L == largestRegionIdx;

    leaf_mask = logical(1 - bg_mask);

    % s = regionprops(leaf_mask, 'MajorAxisLength', 'MinorAxisLength', ...
    %     'Area', 'Perimeter', 'Eccentricity', 'Solidity');

    s = regionprops(leaf_mask, 'MajorAxisLength', 'MinorAxisLength', 'Eccentricity', 'Solidity', 'Perimeter', 'Area', 'Circularity');

    d = zeros(44,1,'single');

    % HSV = rgb2hsv(im).* single(leaf_mask);

    % lin = rgb2lin(im);
    % ycbcrlin = rgb2ycbcr(lin);

    % gim = rgb2gray(im);

    % glcm = normglcm(ycbcrlin(:,:,1), 256, leaf_mask);

    %[strong,weak,~] = extract_edges(ycbcrlin(:,:,1));

    norm_factor = hypot(s.MajorAxisLength*0.5, s.MinorAxisLength*0.5);
    sig = signature_interp(leaf_mask, 256) ./ norm_factor;

    num_bins = 31;
    bin_edges = linspace(1/32, 1, num_bins+1);
    counts = histcounts(sig, bin_edges);

    d(1:31) = counts;

    moments = py_hu_moments(leaf_mask);

    d(32:35) = moments(1:4);
    d(36) = moments(6);

    d(37) = s.MajorAxisLength;
    d(38) = s.MinorAxisLength;
    d(39) = s.Area;
    d(40) = s.Perimeter;

    d(37:40) = d(37:40) / norm_factor;
    
    d(41) = s.Eccentricity;
    d(42) = s.Solidity;
    d(43) = s.Circularity;

    d(44) = std(counts);
end
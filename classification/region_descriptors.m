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

    s = regionprops(leaf_mask, 'MajorAxisLength', 'MinorAxisLength');

    d = zeros(39,1,'single');

    % HSV = rgb2hsv(im).* single(leaf_mask);

    % lin = rgb2lin(im);
    % ycbcrlin = rgb2ycbcr(lin);

    % gim = rgb2gray(im);

    % glcm = normglcm(ycbcrlin(:,:,1), 256, leaf_mask);

    %[strong,weak,~] = extract_edges(ycbcrlin(:,:,1));

    sig_norm_factor = hypot(s.MajorAxisLength*0.5, s.MinorAxisLength*0.5);
    sig = signature_interp(leaf_mask, 256) ./ sig_norm_factor;

    num_bins = 32;
    bin_edges = linspace(0, 1, num_bins+1);
    counts = histcounts(sig, bin_edges);

    d(1:32) = counts;
    d(33:39) = py_hu_moments(leaf_mask);

    % d(8) = s.MajorAxisLength;
    % d(9) = s.MinorAxisLength;
    % d(10) = s.Perimeter;
    % 
    % d(11) = s.Eccentricity;
    % d(12) = s.Solidity;
    % 
    % d(13) = std(std(glcm));
    % d(14) = sum(sum(strong)) / sum(sum(weak));
    % 
    % leaf_area = nnz(leaf_mask);
    % im_area = size(im,1) * size(im,2);
    % d(8:10) = d(8:10) / (leaf_area * im_area);
end
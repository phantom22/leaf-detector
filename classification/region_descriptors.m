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

    masked = im .* leaf_mask;
    gim = im2gray(masked);

    %mask_nnz = nnz(leaf_mask);

    % s = regionprops(leaf_mask, 'MajorAxisLength', 'MinorAxisLength', ...
    %     'Area', 'Perimeter', 'Eccentricity', 'Centroid', 'Circularity', ...
    %     'Solidity', 'ConvexHull', 'ConvexArea');

    s = regionprops(leaf_mask, 'MajorAxisLength', 'MinorAxisLength', ...
        'Area', 'Perimeter');

    d = zeros(11,1,'single');

    d(1:7) = hu_moments(leaf_mask);

    d(8) = s.MajorAxisLength;
    d(9) = s.MinorAxisLength;
    d(10) = s.Area;
    d(11) = s.Perimeter;

    im_area = size(im,1) * size(im,2);
    leaf_area = nnz(leaf_mask);
    d(8:11) = d(8:11) / (sqrt(leaf_area) * sqrt(im_area));

    %d = zeros(7,1,'single');

    % ConvexPerimeter = cellfun(@(hull) sum(sqrt(sum(diff([hull; hull(1, :)], 1, 1).^2, 2))), {s.ConvexHull});
    % 
    % d(1) = s.MajorAxisLength;
    % d(2) = s.MinorAxisLength;
    % d(3) = s.Area;
    % d(4) = s.Perimeter;
    % d(5) = s.MajorAxisLength / s.MinorAxisLength;
    % 
    % d(6) = s.Perimeter / s.MajorAxisLength;
    % d(7) = d(6) / s.MinorAxisLength;
    % d(8) = ConvexPerimeter / s.Perimeter;
    % 
    % d(9) = s.Eccentricity;
    % d(10) = s.Circularity;
    % d(11) = s.Solidity;
    % 
    % nglcm = normglcm(gim, 256, logical(leaf_mask));
    % [~,~,variance,~,~,~,~,~,contrast,uniformity,homogeneity,entropy] = glcmfeatures(nglcm);
    % 
    % d(12) = variance;
    % d(13) = contrast;
    % d(14) = uniformity;
    % d(15) = homogeneity;
    % d(16) = entropy;
    % 
    % [hist_uniformity, ~] = stripped_binfeatures(gim, 256, logical(leaf_mask));

    %d(17) = hist_uniformity;

    %im_area = size(im,1) * size(im,2);
    %d(1:8) = d(1:8) / im_area;

    % L5 = [1 4 6 4 1]; 
    % E5 = [-1 -2 0 2 1];
    % S5 = [-1 0 2 0 -1];
    % R5 = [1 -4 6 -4 1];

    %d(21) = sum(sum(conv2(L5,L5,gim,'same'))) / mask_nnz;
    % d(21) = sum(sum(conv2(L5,E5,gim,'same').^2));
    % d(22) = sum(sum(conv2(L5,S5,gim,'same').^2));
    % d(23) = sum(sum(conv2(L5,R5,gim,'same').^2));
    % d(24) = sum(sum(conv2(E5,E5,gim,'same').^2));
    % d(25) = sum(sum(conv2(E5,S5,gim,'same').^2));
    % d(26) = sum(sum(conv2(E5,R5,gim,'same').^2));
    % d(27) = sum(sum(conv2(S5,S5,gim,'same').^2));
    % d(28) = sum(sum(conv2(R5,R5,gim,'same').^2));

    %LAP = [-1 -1 -1;
    %       -1  8 -1;
    %       -1 -1 -1];

    %d(29) = sum(sum(imfilter(gim, LAP, 'same'))) / mask_nnz;

    %ycbcrim = rgb2ycbcr(masked);
    %d(31) = sum(sum(ycbcrim(:,:,2))) / mask_nnz;

    %d(32:95) = signature_interp(leaf_mask, 64);

    %data(65,1) = sum(sum(mylaplacian(im2gray(im_foglia) .* cl_leaf_mask))) / nnz(cl_leaf_mask);

    %[M20,M02] = compute_moments(cl_leaf_mask);
    %data(66,1) = M20 - M02;
end


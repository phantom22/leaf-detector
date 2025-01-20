function data = region_descriptors(im_foglia, leaf_mask)
    inv_mask = 1 - leaf_mask;
    L = bwlabel(inv_mask);

    stats = regionprops(inv_mask, 'Area');
    [~, largestRegionIdx] = max([stats.Area]);
    bg_mask = L == largestRegionIdx;

    cl_leaf_mask = single(1 - bg_mask);

    data = zeros(66,1,'single');

    data(1:64,1) = signature_interp(cl_leaf_mask, 64);
    data(65,1) = sum(sum(mylaplacian(im2gray(im_foglia) .* cl_leaf_mask))) / nnz(cl_leaf_mask);

    [M20,M02] = compute_moments(cl_leaf_mask);
    data(66,1) = M20 - M02;
end


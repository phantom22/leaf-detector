function out = test_extract_glcm_descriptors(im, num_superpixels)
    tic;
    if ~isa(im,'single')
        im = im2single(im);
    end

    %noshadowim = im ./ imgaussfilt(rgb2gray(im),gaussiansigma(50),"Padding","symmetric");
    %ns_min = min(min(min(noshadowim)));
    %ns_max = max(max(max(noshadowim)));
    %noshadowim = medfilt3((noshadowim - ns_min)  / (ns_max - ns_min), [9 9 1], "symmetric");
    %noshadowim = imgaussfilt3(noshadowim, gaussiansigma(3));

    [SP,N_SP] = superpixels(im, num_superpixels, ...
                     'Method', 'slic', ...
                     'Compactness', 18);

    rprops = regionprops(SP, 'BoundingBox');

    bbox = vertcat(rprops.BoundingBox);
    xstart = floor(bbox(:, 1)) + 1;  % Starting x-coordinates
    ystart = floor(bbox(:, 2)) + 1;  % Starting y-coordinates
    xend = xstart + floor(bbox(:, 3)) - 1;  % Ending x-coordinates
    yend = ystart + floor(bbox(:, 4)) - 1;  % Ending y-coordinates
    iX = arrayfun(@(s, e) s:e, xstart, xend, 'UniformOutput', false);
    iY = arrayfun(@(s, e) s:e, ystart, yend, 'UniformOutput', false);
  
    hsvim = rgb2hsv(im);
    %sim = hsvim(:,:,2);
    gim = hsvim(:,:,3);

    descriptors = zeros(N_SP, 15, 'single'); % rgb + 16x16 glcm

    for k = 1:N_SP
        ry = iY{k};
        rx = iX{k};
        cmask = SP(ry, rx) == k; % cropped mask
        npixels = nnz(cmask);

        [e_x, e_y, var_x, var_y, std_x, std_y, max_prob, corr, contrast, uniformity, homogeneity, entr] = glcmfeatures(normglcm(gim(ry,rx), 64, cmask));

        descriptors(k,1:3) = sum(sum( im(ry,rx) .* cmask )) / npixels;
        descriptors(k,4) = e_x;
        descriptors(k,5) = e_y;
        descriptors(k,6) = var_x;
        descriptors(k,7) = var_y;
        descriptors(k,8) = std_x;
        descriptors(k,9) = std_y;
        descriptors(k,10) = max_prob;
        descriptors(k,11) = corr;
        descriptors(k,12) = contrast;
        descriptors(k,13) = uniformity;
        descriptors(k,14) = homogeneity;
        descriptors(k,15) = entr;
    end

    descriptors(:,1:15) = normalize(descriptors(:,1:15), 'norm');

    out.descriptors = descriptors;
    out.superpixels = SP;
    out.num_superpixels = N_SP;
    out.original_size = size(im);
    toc;
end
function out = seg_descriptors(im, num_superpixels, compactness)
    if ~isa(im,'single')
        im = im2single(im);
    end

    [SP,N_SP] = superpixels(im, num_superpixels, ...
                     'Method', 'slic', ...
                     'Compactness', 25);

    rprops = regionprops(SP, 'BoundingBox');

    bbox = vertcat(rprops.BoundingBox);
    xstart = floor(bbox(:, 1)) + 1;  % Starting x-coordinates
    ystart = floor(bbox(:, 2)) + 1;  % Starting y-coordinates
    xend = xstart + floor(bbox(:, 3)) - 1;  % Ending x-coordinates
    yend = ystart + floor(bbox(:, 4)) - 1;  % Ending y-coordinates
    iX = arrayfun(@(s, e) s:e, xstart, xend, 'UniformOutput', false);
    iY = arrayfun(@(s, e) s:e, ystart, yend, 'UniformOutput', false);

    hsvim = rgb2hsv(im);
    sim = hsvim(:,:,2);
    gim = hsvim(:,:,3);

    ycbcrim = rgb2ycbcr(im);
    cbim = ycbcrim(:,:,2);
    %crim = ycbcrim(:,:,3);

    labim = rgb2lab(im);
    aim = labim(:,:,2);

    [sobel,sobel_dir] = mysobel(gim, 1/2);

    num_features = 10;
    descriptors = zeros(N_SP, num_features, 'single');

    for k = 1:N_SP
        ry = iY{k};
        rx = iX{k};
        cmask = SP(ry, rx) == k; % cropped mask
        mass = nnz(cmask);
        [unif,entr] = stripped_binfeatures(gim(ry,rx), 256, cmask);

        descriptors(k,1:3) = sum(sum( im(ry,rx) .* cmask )) / mass;
        descriptors(k,4) = sum(sum( cbim(ry,rx) .* cmask )) / mass;
        %descriptors(k,5) = sum(sum( crim(ry,rx) .* cmask )) / mass;
        descriptors(k,5) = sum(sum( aim(ry,rx) .* cmask )) / mass;
        descriptors(k,6) = sum(sum( sim(ry,rx) .* cmask )) / mass;
        descriptors(k,7) = unif;
        descriptors(k,8) = entr;
        descriptors(k,9) = sum(sum( sobel(ry,rx) .* cmask )) / mass;
        descriptors(k,10) = sum(sum( sobel_dir(ry,rx) .* cmask )) / mass;
    end

    descriptors(:,1:num_features) = normalize(descriptors(:,1:num_features),'norm');

    out.descriptors = descriptors;
    out.superpixels = SP;
    out.num_superpixels = N_SP;
    out.original_size = size(im);
end
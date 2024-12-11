function out = extract_slic_descriptors(im, num_superpixels)
    tic;
    if ~isa(im,'single')
        im = im2single(im);
    end

    [SP,N_SP] = superpixels(im, num_superpixels, ...
                     'Method', 'slic', ...
                     'Compactness', 13);

    rprops = regionprops(SP, 'BoundingBox');

    bbox = vertcat(rprops.BoundingBox);
    xstart = floor(bbox(:, 1)) + 1;  % Starting x-coordinates
    ystart = floor(bbox(:, 2)) + 1;  % Starting y-coordinates
    xend = xstart + floor(bbox(:, 3)) - 1;  % Ending x-coordinates
    yend = ystart + floor(bbox(:, 4)) - 1;  % Ending y-coordinates
    iX = arrayfun(@(s, e) s:e, xstart, xend, 'UniformOutput', false);
    iY = arrayfun(@(s, e) s:e, ystart, yend, 'UniformOutput', false);
  
    % 2 per le i filtri più grandi (maschere di law)
    %pim = padarray(im, [2,2], 'symmetric');
    %pSP = padarray(SP, [2,2], 'replicate');

    hsvim = rgb2hsv(im);
    %him = hsvim(:,:,1);
    sim = hsvim(:,:,2);
    gim = hsvim(:,:,3);

    [sobel,sobel_dir] = mysobel(gim, 0);
    [spot,ripple,edge_ripple,edge_spot,edge_wave] = leaf_law(gim);

    descriptors = zeros(N_SP, 11, 'single');

    for k = 1:N_SP
        ry = iY{k};
        rx = iX{k};
        cmask = SP(ry, rx) == k; % cropped mask
        npixels = nnz(cmask);

        descriptors(k,1:3) = sum(sum( im(ry,rx) .* cmask )) / npixels;
        descriptors(k,4) = sum(sum( sim(ry,rx) .* cmask )) / npixels;
        descriptors(k,5) = sum(sum( sobel(ry,rx) .* cmask )) / npixels;
        descriptors(k,6) = sum(sum( sobel_dir(ry,rx) .* cmask )) / npixels;
        descriptors(k,7) = sum(sum( spot(ry,rx) .* cmask )) / npixels;
        descriptors(k,8) = sum(sum( ripple(ry,rx) .* cmask )) / npixels;
        descriptors(k,9) = sum(sum( edge_ripple(ry,rx) .* cmask )) / npixels;
        descriptors(k,10) = sum(sum( edge_spot(ry,rx) .* cmask )) / npixels;
        descriptors(k,11) = sum(sum( edge_wave(ry,rx) .* cmask )) / npixels;
    end

    out.descriptors = descriptors;
    out.superpixels = SP;
    out.num_superpixels = N_SP;
    out.original_size = size(im);
    toc;
end
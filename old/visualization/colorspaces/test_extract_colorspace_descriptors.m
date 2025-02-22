function out = test_extract_colorspace_descriptors(im, num_superpixels, compactness)
    %tic;
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
                     'Compactness', compactness);

    rprops = regionprops(SP, 'BoundingBox');

    bbox = vertcat(rprops.BoundingBox);
    xstart = floor(bbox(:, 1)) + 1;  % Starting x-coordinates
    ystart = floor(bbox(:, 2)) + 1;  % Starting y-coordinates
    xend = xstart + floor(bbox(:, 3)) - 1;  % Ending x-coordinates
    yend = ystart + floor(bbox(:, 4)) - 1;  % Ending y-coordinates
    iX = arrayfun(@(s, e) s:e, xstart, xend, 'UniformOutput', false);
    iY = arrayfun(@(s, e) s:e, ystart, yend, 'UniformOutput', false);
  
    hsvim = rgb2hsv(im);
    ycbcrim = rgb2ycbcr(im);
    labim = rgb2lab(im);
    linim = rgb2lin(im);
    gim = rgb2gray(im);

    descriptors = zeros(N_SP, 13, 'single');

    for k = 1:N_SP
        ry = iY{k};
        rx = iX{k};
        cmask = SP(ry, rx) == k; % cropped mask
        mass = nnz(cmask);

        descriptors(k,1:3) = sum(sum( hsvim(ry,rx) .* cmask )) / mass;
        descriptors(k,4:6) = sum(sum( ycbcrim(ry,rx) .* cmask )) / mass;
        descriptors(k,7:9) = sum(sum( labim(ry,rx) .* cmask )) / mass;
        descriptors(k,10:12) = sum(sum( linim(ry,rx) .* cmask )) / mass;
        descriptors(k,13) = sum(sum( gim(ry,rx) .* cmask )) / mass;
    end
    descriptors(:,1:13) = normalize(descriptors(:,1:13),'norm');

    out.descriptors = descriptors;
    out.superpixels = SP;
    out.num_superpixels = N_SP;
    out.original_size = size(im);
    %toc;
end
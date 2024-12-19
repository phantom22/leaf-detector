function out = extract_slic_descriptors(im, num_superpixels, compactness)
    %tic;
    if ~isa(im,'single')
        im = im2single(im);
    end

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
  
    %linim = rgb2lin(im);

    hsvim = rgb2hsv(im);
    sim = hsvim(:,:,2);
    gim = hsvim(:,:,3);

    fgim = imgaussfilt(gim,gaussiansigma(2));

    ycbcrim = rgb2ycbcr(im);
    cbim = ycbcrim(:,:,2);

    labim = rgb2lab(im);
    aim = labim(:,:,2);

    %[sobel,~] = mysobel(gim, 1);
    %L = leaf_law(gim);

    num_features = 9;
    descriptors = zeros(N_SP, num_features, 'single');

    for k = 1:N_SP
        ry = iY{k};
        rx = iX{k};
        cmask = SP(ry, rx) == k; % cropped mask
        mass = nnz(cmask);
        bins = normbins(fgim(ry,rx), 256, cmask);
        %glcm = normglcm(gim(ry,rx), 32, cmask);
        [~,~,~,~,~,~,unif,entr] = binfeatures(bins);
        %[~,~,~,~,~,~,~,~,~,unif,~,~] = glcmfeatures(glcm);

        descriptors(k,1:3) = sum(sum( im(ry,rx) .* cmask )) / mass;
        descriptors(k,4) = sum(sum( fgim(ry,rx) .* cmask )) / mass;
        descriptors(k,5) = sum(sum( cbim(ry,rx) .* cmask )) / mass;
        descriptors(k,6) = sum(sum( aim(ry,rx) .* cmask )) / mass;
        descriptors(k,7) = sum(sum( sim(ry,rx) .* cmask )) / mass;
        %descriptors(k,7) = var;
        descriptors(k,8) = unif;
        descriptors(k,9) = entr;
    end

    descriptors(:,1:num_features) = normalize(descriptors(:,1:num_features),'norm');

    out.descriptors = descriptors;
    out.superpixels = SP;
    out.num_superpixels = N_SP;
    out.original_size = size(im);
    %toc;
end
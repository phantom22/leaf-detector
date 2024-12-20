function [out,sob_g,sob_m,lap_g,lap_m,canny_m] = test_extract_sobel_and_laplacian_descriptors(im, num_superpixels)
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

    fgim = imgaussfilt(gim,gaussiansigma(9),'Padding','symmetric');
    sob_g = mysobel(gim, 0.5);
    sob_m = edge(fgim,'sobel');
    lap_g = mylaplacian(gim);
    lap_m = edge(fgim,'zerocross');
    canny_m = edge(fgim,'canny',0.225);

    descriptors = zeros(N_SP, 5, 'single');

    for k = 1:N_SP
        ry = iY{k};
        rx = iX{k};
        cmask = SP(ry, rx) == k; % cropped mask
        npixels = nnz(cmask);

        descriptors(k,1) = sum(sum( sob_g(ry,rx) .* cmask )) / npixels;
        descriptors(k,2) = sum(sum( sob_m(ry,rx) .* cmask )) / npixels;
        descriptors(k,3) = sum(sum( lap_g(ry,rx) .* cmask )) / npixels;
        descriptors(k,4) = sum(sum( lap_m(ry,rx) .* cmask )) / npixels;
        descriptors(k,5) = sum(sum( canny_m(ry,rx) .* cmask )) / npixels;
    end

    descriptors(:,1:5) = normalize(descriptors(:,1:5), 'norm');

    out.descriptors = descriptors;
    out.superpixels = SP;
    out.num_superpixels = N_SP;
    out.original_size = size(im);
    %toc;
end
function out = extract_slic_descriptors(im, num_superpixels)
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

    %[sobel,~] = mysobel(gim, 1);
    [spot,ripple,edge_ripple,edge_spot,edge_wave] = leaf_law(gim);

    descriptors = zeros(N_SP, 8, 'single');

    for k = 1:N_SP
        ry = iY{k};
        rx = iX{k};
        cmask = SP(ry, rx) == k; % cropped mask
        npixels = nnz(cmask);

        descriptors(k,1:3) = sum(sum( im(ry,rx) .* cmask )) / npixels;
        %descriptors(k,9) = sum(sum( sobel(ry,rx) .* cmask )) / npixels;
        
        %descriptors(k,4) = sum(sum( sim(ry,rx) .* cmask )) / npixels;
        %descriptors(k,5) = sum(sum( sobel(ry,rx) .* cmask )) / npixels;
        %descriptors(k,6) = sum(sum( sobel_dir(ry,rx) .* cmask )) / npixels;
        descriptors(k,4) = sum(sum( spot(ry,rx) .* cmask )) / npixels;
        descriptors(k,5) = sum(sum( ripple(ry,rx) .* cmask )) / npixels;
        descriptors(k,6) = sum(sum( edge_ripple(ry,rx) .* cmask ));
        descriptors(k,7) = sum(sum( edge_spot(ry,rx) .* cmask ));
        descriptors(k,8) = sum(sum( edge_wave(ry,rx) .* cmask )) / npixels;
    end

    descriptors(:,4:8) = normalize(descriptors(:,4:8), 'norm');


    out.descriptors = descriptors;
    out.superpixels = SP;
    out.num_superpixels = N_SP;
    out.original_size = size(im);
    toc;
end
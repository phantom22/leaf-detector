function [out,LL,LE,LS,LR,LW,EL,EE,ES,ER,EW,SL,SE,SS,SR,SW,RL,RE,RS,RR,RW,WL,WE,WS,WR,WW] = test_extract_law_descriptors(im, num_superpixels)
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
    
    lab = rgb2lab(im);
    lim = hsvim(:,:,1);

    %[sobel,~] = mysobel(gim, 1);
    [LL,LE,LS,LR,LW,EL,EE,ES,ER,EW,SL,SE,SS,SR,SW,RL,RE,RS,RR,RW,WL,WE,WS,WR,WW] = test_law(gim);

    LE(1:2,:) = 0;
    LE(:,1:2) = 0;
    LE(end-1:end,:) = 0;
    LE(:,end-1:end) = 0;

    LS(1:2,:) = 0;
    LS(:,1:2) = 0;
    LS(end-1:end,:) = 0;
    LS(:,end-1:end) = 0;

    LR(1:2,:) = 0;
    LR(:,1:2) = 0;
    LR(end-1:end,:) = 0;
    LR(:,end-1:end) = 0;

    LW(1:2,:) = 0;
    LW(:,1:2) = 0;
    LW(end-1:end,:) = 0;
    LW(:,end-1:end) = 0;

    EL(1:2,:) = 0;
    EL(:,1:2) = 0;
    EL(end-1:end,:) = 0;
    EL(:,end-1:end) = 0;

    SL(1:2,:) = 0;
    SL(:,1:2) = 0;
    SL(end-1:end,:) = 0;
    SL(:,end-1:end) = 0;

    RL(1:2,:) = 0;
    RL(:,1:2) = 0;
    RL(end-1:end,:) = 0;
    RL(:,end-1:end) = 0;

    WL(1:2,:) = 0;
    WL(:,1:2) = 0;
    WL(end-1:end,:) = 0;
    WL(:,end-1:end) = 0;

    descriptors = zeros(N_SP, 28, 'single');

    for k = 1:N_SP
        ry = iY{k};
        rx = iX{k};
        cmask = SP(ry, rx) == k; % cropped mask
        npixels = nnz(cmask);

        descriptors(k,1:3) = sum(sum( im(ry,rx) .* cmask )) / npixels;

        descriptors(k,4) = sum(sum( LL(ry,rx) .* cmask ));
        descriptors(k,5) = sum(sum( LE(ry,rx) .* cmask ));
        descriptors(k,6) = sum(sum( LS(ry,rx) .* cmask ));
        descriptors(k,7) = sum(sum( LR(ry,rx) .* cmask ));
        descriptors(k,8) = sum(sum( LW(ry,rx) .* cmask ));

        descriptors(k,9) = sum(sum( EL(ry,rx) .* cmask ));
        descriptors(k,10) = sum(sum( EE(ry,rx) .* cmask ));
        descriptors(k,11) = sum(sum( ES(ry,rx) .* cmask ));
        descriptors(k,12) = sum(sum( ER(ry,rx) .* cmask ));
        descriptors(k,13) = sum(sum( EW(ry,rx) .* cmask ));

        descriptors(k,14) = sum(sum( SL(ry,rx) .* cmask ));
        descriptors(k,15) = sum(sum( SE(ry,rx) .* cmask ));
        descriptors(k,16) = sum(sum( SS(ry,rx) .* cmask ));
        descriptors(k,17) = sum(sum( SR(ry,rx) .* cmask ));
        descriptors(k,18) = sum(sum( SW(ry,rx) .* cmask ));

        descriptors(k,19) = sum(sum( RL(ry,rx) .* cmask ));
        descriptors(k,20) = sum(sum( RE(ry,rx) .* cmask ));
        descriptors(k,21) = sum(sum( RS(ry,rx) .* cmask ));
        descriptors(k,22) = sum(sum( RR(ry,rx) .* cmask ));
        descriptors(k,23) = sum(sum( RW(ry,rx) .* cmask ));

        descriptors(k,24) = sum(sum( WL(ry,rx) .* cmask ));
        descriptors(k,25) = sum(sum( WE(ry,rx) .* cmask ));
        descriptors(k,26) = sum(sum( WS(ry,rx) .* cmask ));
        descriptors(k,27) = sum(sum( WR(ry,rx) .* cmask ));
        descriptors(k,28) = sum(sum( WW(ry,rx) .* cmask ));

        descriptors(k,29) = sum(sum( lim(ry,rx) .* cmask )) / npixels;
    end

    descriptors(:,4:29) = normalize(descriptors(:,4:29), 'zscore');

    out.descriptors = descriptors;
    out.superpixels = SP;
    out.num_superpixels = N_SP;
    out.original_size = size(im);
    %toc;
end
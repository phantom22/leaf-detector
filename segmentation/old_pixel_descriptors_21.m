function d = pixel_descriptors(im)
    if ~isa(im,'single')
        im = im2single(im);
    end

    load('segmentation/gabordata.mat','gabor_filters','gabor_sigmas');

    d = zeros(size(im,1),size(im,2),21,'single');

    hsvim = rgb2hsv(im);
    gim = imgaussfilt(hsvim(:,:,3), 1.5);
    ycbcrim = rgb2ycbcr(im);
    labim = rgb2lab(im);
    [~,sobel_dir] = mysobel(gim, 1/2);

    d(:,:,1) = max(hsvim(:,:,2), 0); % s
    d(:,:,2) = ycbcrim(:,:,2); % cb
    d(:,:,3) = labim(:,:,1); % l
    d(:,:,4) = labim(:,:,2); % a
    d(:,:,5) = labim(:,:,3); % b
    d(:,:,5) = sobel_dir;

    gabormag = imgaborfilt(im(:,:,3), gabor_filters);
    gabormag = arrayfun(@(i) imgaussfilt(gabormag(:,:,i), gabor_sigmas(i)), 1:16, 'UniformOutput', false);
    d(:,:,6:21) = cat(3, gabormag{:});

    d = reshape(d, [], 21);
end
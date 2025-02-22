% models/segmentation/wb-360gabor-10_pct_noise_9f-lin-blue-pixel-classifier.mat

function d = pixel_descriptors(im)
    if ~isa(im,'single')
        im = im2single(im);
    end

    load('segmentation/gabordata.mat','gabor_filters','gabor_sigmas');

    d = zeros(size(im,1),size(im,2),9,'single');

    lin = rgb2lin(im);
    hsvim = rgb2hsv(im);
    v = imgaussfilt(hsvim(:,:,3), 1.5);

    ycbcrim = rgb2ycbcr(lin);
    
    labim = rgb2lab(im);
    [sobel,sobel_dir] = mysobel(v, 1/2);

    lap = mylaplacian(v);

    d(:,:,1) = min(max(hsvim(:,:,2), 0), 1); % s
    d(:,:,2) = ycbcrim(:,:,3); % lin cr
    d(:,:,3) = labim(:,:,2); % a
    d(:,:,4) = labim(:,:,3); % b
    d(:,:,5) = sobel + lap; % similar to L
    d(:,:,6) = sobel_dir;

    gabormag = imgaborfilt(im(:,:,3), gabor_filters);
    gabormag = arrayfun(@(i) imgaussfilt(gabormag(:,:,i), gabor_sigmas(i)), 1:24, 'UniformOutput', false);
    gabormag = cat(3, gabormag{:});

    d(:,:,7) = gabormag(:,:,1)+gabormag(:,:,4)+gabormag(:,:,7)+gabormag(:,:,10)+gabormag(:,:,13)+gabormag(:,:,16)+gabormag(:,:,19)+gabormag(:,:,22);
    d(:,:,8) = gabormag(:,:,2)+gabormag(:,:,5)+gabormag(:,:,8)+gabormag(:,:,11)+gabormag(:,:,14)+gabormag(:,:,17)+gabormag(:,:,20)+gabormag(:,:,23);
    d(:,:,9) = gabormag(:,:,3)+gabormag(:,:,6)+gabormag(:,:,9)+gabormag(:,:,12)+gabormag(:,:,15)+gabormag(:,:,18)+gabormag(:,:,21)+gabormag(:,:,24);

    d = reshape(d, [], 9);
end
% models/segmentation/11f-wb-360gabor-mixed_texture-10%_noise-pixel-classifier.mat

function d = pixel_descriptors(im)
    if ~isa(im,'single')
        im = im2single(im);
    end

    load('segmentation/gabordata.mat','gabor_filters','gabor_sigmas');

    d = zeros(size(im,1),size(im,2),11,'single');

    hsvim = rgb2hsv(im);
    gim = imgaussfilt(rgb2gray(im), 1.5);
    v_gauss = imgaussfilt(hsvim(:,:,3), 1.5);
    ycbcrim = rgb2ycbcr(im);
    labim = rgb2lab(im);
    [sobel,sobel_dir] = mysobel(v_gauss, 1/2);
    lap = mylaplacian(v_gauss);

    d(:,:,1) = min(max(hsvim(:,:,2), 0), 1); % s
    d(:,:,2) = ycbcrim(:,:,2); % cb
    d(:,:,3) = ycbcrim(:,:,3); % cr
    d(:,:,4) = labim(:,:,2); % a
    d(:,:,5) = labim(:,:,3); % b
    d(:,:,6) = sobel + lap; % similar to L
    d(:,:,7) = sobel_dir;

    gabormag = imgaborfilt(gim, gabor_filters);
    gabormag = arrayfun(@(i) imgaussfilt(gabormag(:,:,i), gabor_sigmas(i)), 1:32, 'UniformOutput', false);
    gabormag = cat(3, gabormag{:});

    d(:,:,8) = gabormag(:,:,1)+gabormag(:,:,5)+gabormag(:,:,9)+gabormag(:,:,13)+gabormag(:,:,17)+gabormag(:,:,21)+gabormag(:,:,25)+gabormag(:,:,29);
    d(:,:,9) = gabormag(:,:,2)+gabormag(:,:,6)+gabormag(:,:,10)+gabormag(:,:,14)+gabormag(:,:,18)+gabormag(:,:,22)+gabormag(:,:,26)+gabormag(:,:,30);
    d(:,:,10) = gabormag(:,:,3)+gabormag(:,:,7)+gabormag(:,:,11)+gabormag(:,:,15)+gabormag(:,:,19)+gabormag(:,:,23)+gabormag(:,:,27)+gabormag(:,:,31);
    d(:,:,11) = gabormag(:,:,4)+gabormag(:,:,8)+gabormag(:,:,12)+gabormag(:,:,16)+gabormag(:,:,20)+gabormag(:,:,24)+gabormag(:,:,28)+gabormag(:,:,32);

    d = reshape(d, [], 11);
end
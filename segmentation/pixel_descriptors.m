% models/segmentation/7f-wb-10%_noise-pixel-classifier.mat

function d = pixel_descriptors(im)
    if ~isa(im,'single')
        im = im2single(im);
    end

    d = zeros(size(im,1),size(im,2),7,'single');

    hsvim = rgb2hsv(im);
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

    d = reshape(d, [], 7);
end
function d = pixel_descriptors(im)
    if ~isa(im,'single')
        im = im2single(im);
    end

    load('segmentation/gabordata.mat','gabor_filters','gabor_sigmas');

    d = zeros(size(im,1),size(im,2),27,'single');

    hsvim = rgb2hsv(im);
    gim = imgaussfilt(hsvim(:,:,3), 1.5);
    ycbcrim = rgb2ycbcr(im);
    labim = rgb2lab(im);
    [sobel,sobel_dir] = mysobel(gim, 1/2);

    L5 = [1 4 6 4 1]; 
    E5 = [-1 -2 0 2 1];
    S5 = [-1 0 2 0 -1];
    R5 = [1 -4 6 -4 1];
    pim = padarray(gim, [2,2], 'symmetric', 'both');

    d(:,:,1) = hsvim(:,:,2); % s
    d(:,:,2) = ycbcrim(:,:,2); % cb
    %descriptors(:,:,3) = ycbcrim(:,:,3); % cr
    d(:,:,3) = labim(:,:,1); % l
    d(:,:,4) = labim(:,:,2); % a
    %descriptors(:,:,5) = labim(:,:,3); % b
    d(:,:,5) = sobel;
    d(:,:,6) = sobel_dir;
    d(:,:,7) = conv2(L5,L5,pim,'valid');
    d(:,:,8) = conv2(L5,E5,pim,'valid');
    d(:,:,9) = conv2(L5,S5,pim,'valid');
    d(:,:,10) = conv2(L5,R5,pim,'valid');
    d(:,:,11) = conv2(E5,E5,pim,'valid');
    d(:,:,12) = conv2(E5,S5,pim,'valid');
    d(:,:,13) = conv2(E5,R5,pim,'valid');
    d(:,:,14) = conv2(S5,S5,pim,'valid');
    d(:,:,15) = conv2(R5,R5,pim,'valid');

    gabormag = imgaborfilt(im(:,:,3), gabor_filters);
    gabormag = arrayfun(@(i) imgaussfilt(gabormag(:,:,i), gabor_sigmas(i)), 1:12, 'UniformOutput', false);
    d(:,:,16:27) = cat(3, gabormag{:});

    d = reshape(d, [], 27);
end
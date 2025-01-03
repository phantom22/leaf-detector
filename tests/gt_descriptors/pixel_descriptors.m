function descriptors = pixel_descriptors(im)
    if ~isa(im,'single')
        im = im2single(im);
    end

    descriptors = zeros(size(im,1),size(im,2),14,'single');

    hsvim = rgb2hsv(im);
    gim = hsvim(:,:,3);
    ycbcrim = rgb2ycbcr(im);
    labim = rgb2lab(im);
    [sobel,sobel_dir] = mysobel(gim, 1/2);

    L5 = [1 4 6 4 1]; 
    E5 = [-1 -2 0 2 1];
    S5 = [-1 0 2 0 -1];
    R5 = [1 -4 6 -4 1];
    pim = padarray(gim, [2,2], 'symmetric', 'both');

    descriptors(:,:,1) = hsvim(:,:,2);
    descriptors(:,:,2) = ycbcrim(:,:,2);
    descriptors(:,:,3) = labim(:,:,2);
    descriptors(:,:,4) = sobel;
    descriptors(:,:,5) = sobel_dir;
    descriptors(:,:,6) = conv2(L5,L5,pim,'valid');
    descriptors(:,:,7) = conv2(L5,E5,pim,'valid');
    descriptors(:,:,8) = conv2(L5,S5,pim,'valid');
    descriptors(:,:,9) = conv2(L5,R5,pim,'valid');
    descriptors(:,:,10) = conv2(E5,E5,pim,'valid');
    descriptors(:,:,11) = conv2(E5,S5,pim,'valid');
    descriptors(:,:,12) = conv2(E5,R5,pim,'valid');
    descriptors(:,:,13) = conv2(S5,S5,pim,'valid');
    descriptors(:,:,14) = conv2(R5,R5,pim,'valid');

    descriptors = reshape(descriptors, [], 14);
end
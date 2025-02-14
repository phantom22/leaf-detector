function K = segment(im, se)
    im = whitebalance(im);
    K = reshape(load_pixel_classifier().predictFcn(pixel_descriptors(im)), size(im,1:2));
    K = bwopen(bwclose(K,se),se);
end
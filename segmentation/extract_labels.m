function K = extract_labels(im)
    se = strel('diamond',5);

    K = reshape(load_pixel_classifier().predictFcn(pixel_descriptors(im)), size(im,1:2));
    K = bwopen(bwclose(K,se),se);
end
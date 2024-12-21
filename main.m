function main
    im = imread('images/test/test2.jpg');

    desired_superpixel_size = 7;
    num_superpixels = ceil(size(im,1) * size(im,2) / (desired_superpixel_size ^ 2));

    disp(num_superpixels);

    desc = extract_slic_descriptors(im, num_superpixels, 18);
    slic_spectral_clustering(im, desc, 2, true, true);
end
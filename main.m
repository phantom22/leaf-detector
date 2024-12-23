function main
    im = imread('images/E/19.jpg');

    desired_superpixel_size = 5;
    num_superpixels = ceil(size(im,1) * size(im,2) / (desired_superpixel_size ^ 2));

    %disp(num_superpixels);

    tic;
    desc = seg_descriptors(im, num_superpixels, 5);
    toc;
    spectral_clustering(im, desc, 2, true, true);
end
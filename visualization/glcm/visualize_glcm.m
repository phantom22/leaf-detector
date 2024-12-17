function visualize_glcm
    close all;

    im = imread('images/B/1.jpg');

    profile on;
    desc = test_extract_glcm_descriptors(im, 300);
    profile off;
    profile viewer;

    slic_kmeans(im,desc,2,true,true);
end
function main
    im = imread('images/test/test2.jpg');

    desc = extract_slic_descriptors(im, 8000, 18);
    slic_spectral_clustering(im, desc, 2, true, true);
end
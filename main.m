function main
    im = imread('images/F/27.jpg');

    desc = extract_slic_descriptors(im, 5000, 18);
    slic_spectral_clustering(im, desc, 2, true, true);
end
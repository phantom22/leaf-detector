function main
    im = imread('5.jpg');
    desc = extract_slic_descriptors(im, 350);
    slic_kmeans(im, desc, 2, true, true);
end

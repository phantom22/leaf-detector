function main
    im = imread('B1.jpg');
    
    desc = extract_slic_descriptors(im, 300);
    
    slic_kmeans(im, desc, 2, true);
end
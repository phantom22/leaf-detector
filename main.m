function main
    im = imread('A1.jpg');
    t = rgb2(im);
    imshow(t);

    %desc = extract_slic_descriptors(im, 300);
    %slic_kmeans(im, desc, 4, true);
end
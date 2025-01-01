function visualize_glcm
    close all;

    im = imread('images/D/1.jpg');

    %profile on;
    desc = test_extract_glcm_descriptors(im, 4000);
    %profile off;
    %profile viewer;
    descriptors = desc.descriptors;
    SP = desc.superpixels;

    descriptor_labels = {
        'R'; 'G'; 'B';
        'Expected x';'Expected y';'Variance x';
        'Variance y';'Std x';'Std y';
        'Max probability';'Correlation';'Contrast';
        'Uniformity';'Homogeneity';'Entropy';
    };

    num_descriptors = size(descriptors, 2);

    figure_maximized;
    for d=1:num_descriptors
        vals = descriptors(:,d);

        tsubplot(5, 3, d);
        timagesc(vals(SP),descriptor_labels{d});
    end
end
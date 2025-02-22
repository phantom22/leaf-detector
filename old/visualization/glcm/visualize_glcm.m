function visualize_glcm
    close all;

    im = imread('images/A/1.jpg');

    %profile on;
    desc = test_extract_glcm_descriptors(im, 4800);
    %profile off;
    %profile viewer;
    descriptors = desc.descriptors;
    SP = desc.superpixels;

    descriptor_labels = {
        'R'; 'G'; 'B';
        'Mean';'Variance';'Std';
        'Std';'Max probability';'Correlation';'Contrast';
        'Uniformity';'Homogeneity';'Entropy';
    };

    num_descriptors = size(descriptors, 2);

    idx = [1,2,3,4,6,8,9,10,11,12,13,14,15];

    figure_maximized;
    for d=1:length(idx)
        vals = descriptors(:,idx(d));

        tidx = d;
        if tidx == 13
            tidx = 14;
        end
        tsubplot(5, 3, tidx);
        timagesc(vals(SP),descriptor_labels{d});
    end
end
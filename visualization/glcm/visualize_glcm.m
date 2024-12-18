function visualize_glcm
    close all;

    im = imread('images/M/17.jpg');
    desc = test_extract_glcm_descriptors(im, 4000);
    descriptors = desc.descriptors;
    SP = desc.superpixels;

    descriptor_labels = {
        'R'; 'G'; 'B';
        'Expected x';'Expected y';'Variance x';
        'Variance y';'Std x';'Std y';
        'Max probability';'Correlation';'Contrast';
        'Uniformity';'Homogeneity';'Entropy';
    };

    %num_descriptors = size(descriptors, 2);

    f1 = figure;
    f1.WindowState = "maximized";
    for d=1:15
        vals = descriptors(:,d);

        subplot(5, 3, d);
        imagesc(vals(SP));
        axis image;
        axis off;
        title(descriptor_labels{d});
    end

    %disp(descriptors(:,12));
end
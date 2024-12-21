function visualize_bins
    close all;

    im = imread('images/test/test2.jpg');
    %t = medfilt3(im,[5 5 1]);

    %noshadowim = im ./ imgaussfilt(rgb2gray(im),gaussiansigma(50),"Padding","symmetric");
    %ns_min = min(min(min(noshadowim)));
    %ns_max = max(max(max(noshadowim)));
    %noshadowim = medfilt3((noshadowim - ns_min)  / (ns_max - ns_min), [9 9 1], "symmetric");
    %t = imgaussfilt3(noshadowim, gaussiansigma(3));

    desc = test_extract_bin_descriptors(im, 9349, 128);
    descriptors = desc.descriptors;
    SP = desc.superpixels;

    descriptor_labels = {
        'R'; 'G'; 'B';
        'Expected value';'Variance'; 'Std';
        'First moment';'Third moment';
        'Relative variance';'Uniformity';'Entropy';
    };

    num_descriptors = size(descriptors, 2);

    f1 = figure;
    f1.WindowState = "maximized";
    for d=1:num_descriptors
        vals = descriptors(:,d);

        subplot(4, 3, d);
        imagesc(vals(SP));
        axis image;
        axis off;
        title(descriptor_labels{d});
    end

    %disp(descriptors(:,12));
end
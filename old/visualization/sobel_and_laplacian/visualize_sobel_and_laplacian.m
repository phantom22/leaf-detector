function visualize_sobel_and_laplacian
    close all;

    im = imread('images/A/1.jpg');
    %t = medfilt3(im,[5 5 1]);

    %noshadowim = im ./ imgaussfilt(rgb2gray(im),gaussiansigma(50),"Padding","symmetric");
    %ns_min = min(min(min(noshadowim)));
    %ns_max = max(max(max(noshadowim)));
    %noshadowim = medfilt3((noshadowim - ns_min)  / (ns_max - ns_min), [9 9 1], "symmetric");
    %t = imgaussfilt3(noshadowim, gaussiansigma(3));

    [desc,sob_g,sob_m,lap_g,lap_m,canny_m,sob_d] = test_extract_sobel_and_laplacian_descriptors(im, 4800);
    descriptors = desc.descriptors;
    SP = desc.superpixels;

    descriptor_labels = {
        'Sobel Gradient'; 'Sobel Mask';
        'Laplacian Gradient'; 'Laplacian Mask';
        'Canny Mask'; 'Sobel Dir';
    };

    num_descriptors = size(descriptors, 2);

    figure_maximized;
    for d=1:num_descriptors-2
        vals = descriptors(:,d);

        tsubplot(2, 2, d);
        timagesc(vals(SP), descriptor_labels{d});
    end
end
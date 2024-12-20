function visualize_sobel_and_laplacian
    close all;

    im = imread('images/D/11.jpg');
    %t = medfilt3(im,[5 5 1]);

    %noshadowim = im ./ imgaussfilt(rgb2gray(im),gaussiansigma(50),"Padding","symmetric");
    %ns_min = min(min(min(noshadowim)));
    %ns_max = max(max(max(noshadowim)));
    %noshadowim = medfilt3((noshadowim - ns_min)  / (ns_max - ns_min), [9 9 1], "symmetric");
    %t = imgaussfilt3(noshadowim, gaussiansigma(3));

    [desc,sob_g,sob_m,lap_g,lap_m,canny_m] = test_extract_sobel_and_laplacian_descriptors(im, 4800);
    descriptors = desc.descriptors;
    SP = desc.superpixels;

    descriptor_labels = {
        'Sobel Gradient'; 'Sobel Mask';
        'Laplacian Gradient'; 'Laplacian Mask';
        'Canny Mask';
    };

    num_descriptors = size(descriptors, 2);

    f1 = figure;
    f1.WindowState = "maximized";
    for d=1:num_descriptors
        vals = descriptors(:,d);

        subplot(3, 2, d);
        imagesc(vals(SP));
        axis image;
        axis off;
        title(descriptor_labels{d});
    end


    f2 = figure;
    f2.WindowState = "maximized";

    subplot(3, 2, 1);
    imagesc(sob_g);
    axis image;
    axis off;
    title(descriptor_labels{1});

    subplot(3, 2, 2);
    imagesc(sob_m);
    axis image;
    axis off;
    title(descriptor_labels{2});

    subplot(3, 2, 3);
    imagesc(lap_g);
    axis image;
    axis off;
    title(descriptor_labels{3});

    subplot(3, 2, 4);
    imagesc(lap_m);
    axis image;
    axis off;
    title(descriptor_labels{4});

    subplot(3, 2, 5);
    imagesc(canny_m);
    axis image;
    axis off;
    title(descriptor_labels{5});
end
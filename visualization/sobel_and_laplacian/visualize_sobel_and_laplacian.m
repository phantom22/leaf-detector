function visualize_sobel_and_laplacian
    close all;

    im = imread('images/D/11.jpg');
    %t = medfilt3(im,[5 5 1]);

    %noshadowim = im ./ imgaussfilt(rgb2gray(im),gaussiansigma(50),"Padding","symmetric");
    %ns_min = min(min(min(noshadowim)));
    %ns_max = max(max(max(noshadowim)));
    %noshadowim = medfilt3((noshadowim - ns_min)  / (ns_max - ns_min), [9 9 1], "symmetric");
    %t = imgaussfilt3(noshadowim, gaussiansigma(3));

    [desc,sob_g,sob_m,lap_g,lap_m,canny_m,sob_d] = test_extract_sobel_and_laplacian_descriptors(im, 1000);
    descriptors = desc.descriptors;
    SP = desc.superpixels;

    descriptor_labels = {
        'Sobel Gradient'; 'Sobel Mask';
        'Laplacian Gradient'; 'Laplacian Mask';
        'Canny Mask'; 'Sobel Dir';
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

    bdmask = boundarymask(desc.superpixels);
    overlaycol = 'red';

    f2 = figure;
    f2.WindowState = "maximized";

    subplot(3, 2, 1);
    imagesc(imoverlay(sob_g,bdmask,overlaycol))
    axis image;
    axis off;
    title(descriptor_labels{1});

    subplot(3, 2, 2);
    imagesc(imoverlay(sob_m,bdmask,overlaycol))
    axis image;
    axis off;
    title(descriptor_labels{2});

    subplot(3, 2, 3);
    imagesc(imoverlay(lap_g,bdmask,overlaycol))
    axis image;
    axis off;
    title(descriptor_labels{3});

    subplot(3, 2, 4);
    imagesc(imoverlay(lap_m,bdmask,overlaycol));
    axis image;
    axis off;
    title(descriptor_labels{4});

    subplot(3, 2, 5);
    imagesc(imoverlay(canny_m,bdmask,overlaycol));
    axis image;
    axis off;
    title(descriptor_labels{5});

    subplot(3, 2, 6);
    imagesc(imoverlay(sob_d,bdmask,overlaycol));
    axis image;
    axis off;
    title(descriptor_labels{6});
end
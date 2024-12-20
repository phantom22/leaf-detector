function visualize_main
    close all;

    im = imread('images/C/16.jpg');

    desc = extract_slic_descriptors(im, 4800, 18);
    descriptors = desc.descriptors;
    SP = desc.superpixels;
    descriptor_labels = {
        'R'; 'G'; 'B';
        'Cb from YCbCr';'A from LAB';'S from HSV';
        'Histogram Uniformity';'Histogram Entropy';'Sobel Gradient';
    };

    num_descriptors = size(descriptors, 2);

    rows = ceil(num_descriptors / 3);

    f1 = figure;
    f1.WindowState = "maximized";
    for d=1:num_descriptors
        vals = descriptors(:,d);

        subplot(rows, 3, d);
        imagesc(vals(SP));
        axis image;
        axis off;
        title(descriptor_labels{d});
    end

    %disp(descriptors(:,12));
end
function visualize_colorspaces
    close all;

    im = imread('images/B/16.jpg');

    desc = test_extract_colorspace_descriptors(im, 4000, 18);
    descriptors = desc.descriptors;
    SP = desc.superpixels;

    descriptor_labels = {
        'R'; 'G'; 'B';
        'H from HSV';'S from HSV';'V from HSV';
        'Y from YCbCr';'Cb from YCbCr';'Cr from YCbCr';
        'L from LAB';'A from LAB';'B from LAB';
        'X from XYZ';'Y from XYZ';'Z from XYZ';
        'Y from NTSC';'I from NTSC';'Q from NTSC';
        'R from LIN';'G from LIN';'B from LIN';
        'GrayScale'
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
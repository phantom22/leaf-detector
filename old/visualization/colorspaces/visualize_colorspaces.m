function visualize_colorspaces
    close all;

    im = imread('images/A/1.jpg');

    desc = test_extract_colorspace_descriptors(im, 4800, 25);
    descriptors = desc.descriptors;
    SP = desc.superpixels;

    descriptor_labels = {
        'H from HSV';'S from HSV';'V from HSV';
        'Y from YCbCr';'Cb from YCbCr';'Cr from YCbCr';
        'L from LAB';'A from LAB';'B from LAB';
        'R from LIN';'G from LIN';'B from LIN';
        'GrayScale'
    };

    num_descriptors = size(descriptors, 2);

    rows = 5;
    cols = 3;

    %[rows,cols] = calcola_ingombro_minimo_subplot(num_descriptors);

    figure_maximized;
    for d=1:num_descriptors
        vals = descriptors(:,d);

        tidx = d;
        if tidx == 13
            tidx = tidx + 1;
        end

        tsubplot(rows, cols, tidx);
        timagesc(vals(SP), descriptor_labels{d});
    end
end
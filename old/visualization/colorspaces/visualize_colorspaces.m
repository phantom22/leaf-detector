function visualize_colorspaces
    close all;

    im = imread('images/Z/2.jpg');

    desc = test_extract_colorspace_descriptors(im, 4800, 5);
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

    [rows,cols] = calcola_ingombro_minimo_subplot(num_descriptors);

    figure_maximized;
    for d=1:num_descriptors
        vals = descriptors(:,d);

        tsubplot(rows, cols, d);
        timagesc(vals(SP), descriptor_labels{d});
    end
end
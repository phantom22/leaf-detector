function visualize_main
    close all;

    im = imread('images/D/3.jpg');

    desc = seg_descriptors(im, 4800, 25);
    descriptors = desc.descriptors;
    SP = desc.superpixels;
    descriptor_labels = {
        'R'; 'G'; 'B';
        'Cb from YCbCr';'A from LAB';'S from HSV';
        'Histogram Uniformity';'Histogram Entropy';'Sobel Gradient';
        'Sobel Dir';
    };

    num_descriptors = size(descriptors, 2);

    ax_positions = get_minimal_grid(num_descriptors+1);

    figure_maximized;
    for d=1:num_descriptors
        vals = descriptors(:,d);

        tidx = d;

        if tidx >= 9
            tidx = tidx + 1;
        end

        subplot('Position', ax_positions(:,tidx));
        timagesc(vals(SP), descriptor_labels{d});
    end
end
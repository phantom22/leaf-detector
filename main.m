function main
    close all;

    tic;

    im = im2double(imread("images/Z/2.jpg"));
    im = imresize(im, [300 400]);

    ss = strel('disk', 0);
    se = strel('disk',5);
    tic;
    K = extract_labels(im,se);
    [C,counts] = classify(im, K, ss);
    toc;

    figure_maximized;
    ax1 = tsubplot(1,2,1); timagesc(im); colormap(turbo);
    ax2 = tsubplot(1,2,2); visualize_classification(C);
        visualizzaClassi(C);
    linkaxes([ax1,ax2], 'xy');
    axis tight;
end
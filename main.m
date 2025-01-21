function main
    tic;

    im = im2double(imread("images/Z/4.jpg"));

    im = imresize(im, [300 400]);

    se = strel('disk', 5);
    dummy_se = strel('disk', 0);

    tic;
    K = segment(im, se);
    [C,counts] = classify(im, K, dummy_se);
    toc;

    figure_maximized;
    ax1 = tsubplot(1,2,1); timagesc(im); colormap(turbo);
    ax2 = tsubplot(1,2,2); visualize_classification(C);
        visualizzaClassi(C);
    linkaxes([ax1,ax2], 'xy');
    axis tight;
end
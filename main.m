function main
    tic;

    im = im2double(imread("images/A/4.jpg"));

    f = sqrt(size(im,1) * size(im,2) / 120000);

    im = imresize(im, size(im, 1:2) / f);

    %disp(size(im))

    se = strel('disk', 5);
    dummy_se = strel('disk', 0);

    tic;
    K = segment(im, se);

    [C,counts] = classify(im, K, dummy_se);
    toc;

    figure_maximized;
    ax1 = tsubplot(1,2,1); timagesc(im); colormap(turbo);
    ax2 = tsubplot(1,2,2); visualize_classification(C);
    linkaxes([ax1,ax2], 'xy');
    axis tight;
end
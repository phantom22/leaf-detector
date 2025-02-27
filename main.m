function main
    tic;

    im = im2double(imread("images/C/2.jpg"));
    im = imresizetoarea(im, 300*400);

    se = strel('disk', 3);
    dummy_se = strel('disk', 0);

    tic;
    K = segment(im,se);

    [C,~] = classify(im, K, dummy_se);

    figure_maximized;
    ax1 = tsubplot(1,2,1); imshow(im);
    ax2 = tsubplot(1,2,2); visualize_classification(C);
    linkaxes([ax1,ax2], 'xy');
    axis tight;
end
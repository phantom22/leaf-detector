function main
    tic;

    im = im2double(imread("old/images-old/G/B4.jpg")); % "old/images-old/X/17.jpg"
    im = imresizetoarea(im, 300*400*4);

    se = strel('disk', 3);
    dummy_se = strel('disk', 0);

    tic;
    K = segment(im,se);

    [C,~] = classify(im, K, dummy_se);
    toc;

    figure_maximized;
    ax1 = tsubplot(1,3,1); imshow(im);
    ax2 = tsubplot(1,3,2); visualize_classification(C);
    ax3 = tsubplot(1,3,3); imshow(K);
    linkaxes([ax1,ax2,ax3], 'xy');
    axis tight;
end
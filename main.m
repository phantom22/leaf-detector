function main
    tic;

    im = imresizetoarea(im2double(imread("images/A/1.jpg")), 300*400);

    %disp(size(im))

    se = strel('disk', 2);
    dummy_se = strel('disk', 0);

    tic;
    K = segment(im, se);

    %disp(hu_moments(K));
    %disp(feature_vec(K));

    [C,counts] = classify(im, K, dummy_se);
    toc;

    figure_maximized;
    ax1 = tsubplot(1,3,1); timagesc(im); colormap(turbo);
    ax2 = tsubplot(1,3,2); visualize_classification(C);
    ax3 = tsubplot(1,3,3); timagesc(K);
    linkaxes([ax1,ax2,ax3], 'xy');
    axis tight;
end
function test(what)
    im = im2single(imread(what));
    gim = imgaussfilt( rgb2gray(im), 0.7 ); % rgb2gray(im);
    labim = rgb2lab(im);
    t = mysobel(gim, 0.5) + mylaplacian(gim);

    figure_maximized;
    ax1 = tsubplot(1,2,1); imagesc(labim(:,:,1)); title("L"); axis image; axis off; colorbar;
    ax2 = tsubplot(1,2,2); imagesc(t); title("sobel + laplacian"); axis image; axis off; colorbar;

    linkaxes([ax1 ax2], 'xy');
    axis tight;
end
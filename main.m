function main
    close all;

    tic;

    im = im2double(imread("images/Z/19.jpg"));
    im = imresize(im, [size(im,1) size(im,2)] / 2);

    labels = extract_labels(im);

    figure_maximized; 
    ax1 = tsubplot(1,2,1); timagesc(im);
    ax2 = tsubplot(1,2,2); timagesc(labels); colormap(jet);
    linkaxes([ax1,ax2],'xy');
    axis tight;
end
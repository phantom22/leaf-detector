function main
    close all;

    %profile on;

    %load('models\bigger-pixel-classifier.mat','pixel_classifier');
    pixel_classifier = load_pixel_classifier();

    im = im2double(imread("images/Z/6.jpg"));
    im = imresize(im, [size(im,1) size(im,2)] / 4);

    

    disp(size(im));
    %gt = imread("images/test/test_finale_gt.jpg") > 1;
    %gt = imresize(gt, [size(gt,1) size(gt,2)] / 3);

    desc = pixel_descriptors(imgaussfilt(im,gaussiansigma(15)));

    %desc = pixel_descriptors(im);

    P = pixel_classifier.predictFcn(desc);
    labels = reshape(P, size(im,1), size(im,2));

    %profile off;
    %profile viewer;

    se = strel('disk', 7);
    labels = bwopen(labels,se);

    figure_maximized; 
    ax1 = tsubplot(1,2,1); timagesc(im);
    ax2 = tsubplot(1,2,2); timagesc(labels); colormap(jet);
    linkaxes([ax1,ax2],'xy');
    axis tight;

    %fprintf("Errore medio: %.2f%%\n", nnz(gt-labels)/nnz(gt)*100);
end
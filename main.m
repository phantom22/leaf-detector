function main
    load("models\dirty-classificator1.mat","leaf_classificator");

    im = im2double(imread("images/A/1.jpg"));
    num_superpixels = ceil(size(im,1) * size(im,2) / 50);

    fprintf("[num_superpixels %d]\n", num_superpixels);

    desc = seg_descriptors(im, num_superpixels, 25);
    descriptors = desc.descriptors;
    SP = desc.superpixels;
    
    P = leaf_classificator.predictFcn(descriptors);
    K = round(P);
    labels = K(SP);

    figure_maximized; 
    ax1 = tsubplot(1,2,1); imshow(im); colormap("gray");
    ax2 = tsubplot(1,2,2); timagesc(labels);
    linkaxes([ax1,ax2],'xy');
    axis tight;
end
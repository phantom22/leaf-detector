function visualize_pixel_descriptors(im_path)
    im = imresizetoarea(im2single(imread(im_path)), 300*400);

    tic;
    C = pixel_descriptors(im);
    toc;

    num_features = size(C,2);

    im_C = reshape(C, [size(im,1:2),num_features]);

    [m,n] = calcola_ingombro_minimo_subplot(num_features);

    figure_maximized;
    for i=1:num_features
        tsubplot(m,n,i);
        imagesc(im_C(:,:,i));
        axis image;
        axis off;
        colorbar;
    end
end
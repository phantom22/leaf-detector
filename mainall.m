function mainall

    close all;

    [num_images, class_full_paths, class_im_names] = image_paths_from_dir("images/A");

    [m,n] = calcola_ingombro_minimo_subplot(num_images);

    figure_maximized;
    for i=1:num_images
        im = imread(class_full_paths{i});
        im = imresize(im, size(im,1:2)/5);

        tsubplot(m,n,i);
        timagesc(extract_labels(im), class_im_names{i});
    end

end
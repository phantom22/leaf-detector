function batch
    input_dir = 'images/A';
    images = dir(fullfile(input_dir, '*.jpg'));
    images = images(~[images.isdir]);
    fnames = {images.name};
    
    num_images = length(fnames);
    outs = zeros(300, 400, num_images);
    num_superpixels = 200;
    
    tic;
    for k=1:num_images
        im = imread(fullfile(input_dir, fnames{k}));
        desc = extract_slic_descriptors(im, num_superpixels);
        outs(:,:,k) = slic_kmeans(im, desc, 2, false, false);
    end
    toc;
    
    t = figure;
    set(t, 'WindowState', 'maximized');

    subplot_rows = ceil(num_images/4);
    
    for k=1:num_images
        fname = fnames{k};
        subplot(subplot_rows,4,k); imagesc(outs(:,:,k)); colormap(jet); axis image; axis off; title(fname);
        %fprintf("%d/%d '%s' done.\n", k, num_images, fname);
    end
end
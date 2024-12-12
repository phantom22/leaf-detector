function batch
    input_dir = 'images/reduced_size/pianta3g';
    images = dir(input_dir);
    num_images = length(images)-2;
    
    outs = zeros(300, 400, num_images-2);
    num_superpixels = 200;
    
    tic;
    for k=3:num_images+2
        im = imread(fullfile(input_dir, images(k).name));
        desc = extract_slic_descriptors(im, num_superpixels);
        outs(:,:,k-2) = slic_kmeans(im, desc, 2, false, false);
    end
    toc;
    
    t = figure;
    set(t, 'WindowState', 'maximized');
    
    for k=1:num_images
       subplot(5,4,k); imagesc(outs(:,:,k)); colormap(jet); axis image; axis off; title(images(k+2).name);
    end
end
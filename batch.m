function batch
    input_dir = 'images/reduced_size/pianta3g';
    images = dir(fullfile(input_dir, '*.jpg'));
    images = images(~[images.isdir]);
    
    num_images = length(images);
    outs = zeros(300, 400, num_images);
    num_superpixels = 200;
    
    tic;
    for k=1:num_images
        im = imread(fullfile(input_dir, images(k).name));
        desc = extract_slic_descriptors(im, num_superpixels);
        outs(:,:,k) = slic_kmeans(im, desc, 2, false, false);
    end
    toc;
    
    t = figure;
    set(t, 'WindowState', 'maximized');
    
    for k=1:num_images
       subplot(5,4,k); imagesc(outs(:,:,k)); colormap(jet); axis image; axis off; title(images(k).name);
    end
end
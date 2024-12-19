function outs = slic_kmeans_batch(input_dir,clustering_handle,num_superpixels,compactness,num_clusters)
    arguments
        input_dir = 'images/L';
        clustering_handle = @slic_kmeans_clustering;
        num_superpixels = 4000;
        compactness = 18;
        num_clusters = 2;
    end
    close all;

    images = dir(fullfile(input_dir, '*.jpg'));
    images = images(~[images.isdir]); % remove dirs
    fnames = {images.name};
    
    num_images = length(fnames);
    outs = zeros(300, 400, num_images, 'single');

    og_images = zeros(300, 400, 3, num_images, 'uint8');
    
    tic;
    for k=1:num_images
        im = imread(fullfile(input_dir, fnames{k}));
        desc = extract_slic_descriptors(im, num_superpixels,compactness); 
        outs(:,:,k) = clustering_handle(im, desc, num_clusters, false, false);
        og_images(:,:,:,k) = im;
    end
    elapsed = toc;
    fprintf("Elapsed time is %ss (%s per image on average).\n", num2str(elapsed), num2str(elapsed/num_images));

    subplot_rows = ceil(num_images/4);
    
    f1 = figure;
    f1.WindowState = "maximized";
    f1.NumberTitle = 'off';
    f1.Name = strcat("'",input_dir,"' clustered");
    for k=1:num_images
        fname = fnames{k};
        subplot(subplot_rows,4,k); imagesc(outs(:,:,k)); colormap(jet); axis image; axis off; title(fname);
        %fprintf("%d/%d '%s' done.\n", k, num_images, fname);
    end

    f2 = figure;
    f2.WindowState = "maximized";
    f2.NumberTitle = 'off';
    f2.Name = strcat("'",input_dir,"' original");
    for k=1:num_images
        subplot(subplot_rows,4,k); imshow(og_images(:,:,:,k)); title(fnames{k});
        %fprintf("%d/%d '%s' done.\n", k, num_images, fname);
    end
end
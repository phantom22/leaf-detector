function outs = slic_kmeans_batch(input_dir,clustering_handle,num_superpixels,compactness,num_clusters)
    arguments
        input_dir {mustBeTextScalar} = "images/D";
        clustering_handle = @spectral_clustering;
        num_superpixels = 4000;
        compactness = 5;
        num_clusters = 2;
    end
    close all;


    [num_images,fullpaths,fnames] = image_paths_from_dir(input_dir);
    
    outs = zeros(300, 400, num_images, 'single');
    og_images = zeros(300, 400, 3, num_images, 'uint8');

    is_spectral_clustering = isequal(clustering_handle, @spectral_clustering);
    is_kmeans_clustering = isequal(clustering_handle, @kmeans_clustering);
    
    tic;
    for k=1:num_images
        im = imread(fullpaths{k});
        desc = seg_descriptors(im, num_superpixels, compactness); 

        if is_spectral_clustering
            outs(:,:,k) = spectral_clustering(desc, 2.3);
        elseif is_kmeans_clustering
             outs(:,:,k) = kmeans_clustering(desc);
        else
            outs(:,:,k) = clustering_handle(im, desc, num_clusters, false, false);
        end

        og_images(:,:,:,k) = im;
    end
    elapsed = toc;
    fprintf("Elapsed time is %ss (%s per image on average).\n", num2str(elapsed), num2str(elapsed/num_images));

    ax_positions = get_minimal_grid(num_images);
    
    figure_maximized("'",input_dir,"' clustered");
    for k=1:num_images
        fname = fnames{k};
        subplot('Position', ax_positions(:,k));
        timagesc(outs(:,:,k), fname);
    end


    figure_maximized("'",input_dir,"' original");
    for k=1:num_images
        subplot('Position', ax_positions(:,k));
        timshow(og_images(:,:,:,k), fnames{k});
    end
end
function K = dbscan_clustering(im, desc, epsilon, display, draw_slic)
     % euclidean, cityblock, (minkowski,P=3)
    labels = dbscan(desc.descriptors, epsilon, 3000);
    %labels = spectralcluster(desc.descriptors, num_clusters, 'Distance', 'euclidean');

    SP = desc.superpixels;
    K = labels(SP); % riassegna ai superpixel le nuove labels date da kmeans
    
    if ~display
       return;
    end

    num_clusters = max(labels);

    t = figure;
    set(t, 'WindowState', 'maximized');
    
    if ~draw_slic
        ax1 = subplot(1,2,1); imshow(im); title(sprintf("%dx%dx%d", desc.original_size));
        ax2 = subplot(1,2,2); imagesc(K); colormap(jet); axis image; title(sprintf("nsp=%d k=%d", desc.num_superpixels, num_clusters));
        linkaxes([ax1, ax2], 'xy');
    else
        ax1 = subplot(1,3,1); imshow(im); title(sprintf("%dx%dx%d", desc.original_size));
        ax2 = subplot(1,3,2); imagesc(K); colormap(jet); axis image; title(sprintf("nsp=%d k=%d", desc.num_superpixels, num_clusters));
        ax3 = subplot(1,3,3); imshow(imoverlay(im, boundarymask(SP), 'cyan')); colormap(jet); title("overlay");
        linkaxes([ax1, ax2, ax3], 'xy');
    end
    axis tight;
end

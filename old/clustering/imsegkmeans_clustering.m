function K = imsegkmeans_clustering(im, desc, num_clusters, display, draw_slic)
    labels = imsegisodata(desc.descriptors, 'MinClusterSeparation', 2, 'MinSamples', 3500, 'MaxStandardDeviation',2.1); % N_SP x 1
    SP = desc.superpixels;
    K = labels(SP); % riassegna ai superpixel le nuove labels date da kmeans
    
    if ~display
       return;
    end

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
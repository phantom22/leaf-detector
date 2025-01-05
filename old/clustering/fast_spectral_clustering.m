function K = fast_spectral_clustering(im, desc, num_clusters, display, draw_slic)

    sg = double(SimGraph_NearestNeighbors(desc.descriptors', 2, 1, 0));

    labels = SpectralClustering(sg', num_clusters, 1); % 1 = Unnormalized, 2 = Shi and Malik, 3 = Jordan and Weiss.

    [rows, cols] = find(labels); % Get non-zero entries
    cluster_labels = zeros(size(labels, 1), 1); % Initialize label vector
    cluster_labels(rows) = cols; % Assign cluster labels

    % Step 4: Map to superpixels
    SP = desc.superpixels; % Superpixel indices matrix
    K = zeros(size(SP)); % Initialize the output matrix
    
    % Check bounds and assign labels
    valid_indices = SP <= length(cluster_labels); % Valid superpixel indices
    K(valid_indices) = cluster_labels(SP(valid_indices)); % Assign valid labels
    K(~valid_indices) = 0; % Default label for missing entries

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

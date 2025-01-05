function K = kmeans_clustering(desc)
    % K = kmeans_clustering(desc)
    %
    % where K os the two class clustering of desc, using kmeans.
    
    labels = kmeans(desc.descriptors, num_clusters, 'MaxIter', 1000, 'Replicates', 5); % N_SP x 1
    SP = desc.superpixels;
    K = labels(SP); % riassegna ai superpixel le nuove labels date da kmeans
end
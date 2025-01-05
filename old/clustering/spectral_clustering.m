function K = spectral_clustering(desc, pdist)
    % K = spectral_clustering(desc, pdist)
    %
    % where K is the two class clustering of desc, using spectralcluster.

    % euclidean, cityblock, (minkowski,P=3)
    labels = spectralcluster(desc.descriptors, 2, 'Distance', 'minkowski', 'P', pdist);

    SP = desc.superpixels;
    K = labels(SP); % riassegna ai superpixel le nuove labels date da kmeans
end

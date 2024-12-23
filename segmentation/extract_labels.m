function labels = extract_labels(im, num_superpixels, compactness)
    desc = seg_descriptors(im, num_superpixels, compactness);
    labels = spectral_clustering(im, desc, 2, false, false);
    labels = labels-1;
    
    % boundingBox=regionprops(labels,"BoundingBox");
    % %disp([im_path "," int2str( boundingBox.BoundingBox(3)) "," int2str(boundingBox.BoundingBox(4))]);
    % if(boundingBox.BoundingBox(3)==size(labels,2)&&boundingBox.BoundingBox(4)==size(labels,1))
    %      labels=1-labels;
    %  end

    bordi=[labels(:,1); labels(1,:)'; labels(:,end); labels(end,:)'];

    % se più del 50% dei pixel di bordo risultano essere classificati come
    % foglie
    if sum(bordi)/length(bordi) > 0.5
        labels = 1-labels;
    end
end
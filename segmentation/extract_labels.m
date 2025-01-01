function labels = extract_labels(im, num_superpixels)
    desc = seg_descriptors(im, num_superpixels, 5);
    labels = spectral_clustering(desc, 2.3);
    labels = labels-1;
    % boundingBox=regionprops(labels,"BoundingBox");
    % %disp([im_path "," int2str( boundingBox.BoundingBox(3)) "," int2str(boundingBox.BoundingBox(4))]);
    % if(boundingBox.BoundingBox(3)==size(labels,2)&&boundingBox.BoundingBox(4)==size(labels,1))
    %      labels=1-labels;
    %  end

    bordi=[labels(:,1); labels(1,:)'; labels(:,end); labels(end,:)'];

    % (sum(labels(:,1))+sum(labels(1,:))+sum(labels(:,end))+sum(labels(end,:))/(2*size(im,1)+2*size(im,2)))

    % se più del 50% dei pixel di bordo risultano essere classificati come
    % foglie
    if sum(bordi)/length(bordi) > 0.5
        labels = 1-labels;
    end
end
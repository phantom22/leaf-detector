function labels=extract_labels(im,num_superpixels,compactness)
    desc = extract_slic_descriptors(im, num_superpixels, compactness);
    labels = slic_spectral_clustering(im, desc, 2, false, false);
    labels = labels-1;
    
    % boundingBox=regionprops(labels,"BoundingBox");
    % %disp([im_path "," int2str( boundingBox.BoundingBox(3)) "," int2str(boundingBox.BoundingBox(4))]);
    % if(boundingBox.BoundingBox(3)==size(labels,2)&&boundingBox.BoundingBox(4)==size(labels,1))
    %      labels=1-labels;
    %  end

    bordi=[labels(:,1); labels(1,:)'; labels(:,end); labels(end,:)'];
    %disp(double(sum(bordi))/length(bordi));
    if(sum(bordi)/length(bordi)>0.5)
        labels=1-labels;
    end
end
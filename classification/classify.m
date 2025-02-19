function [K,counts] = classify(I,BW,se)
    % I = whitebalance(I);

    leaf_classifier = load_leaf_classifier();
    [labels, numRegions] = bwlabel(BW);

    idx = 1:numRegions;
    if numRegions ~= 1
        props = regionprops(labels, 'Area');
        allAreas = [props.Area];

        %disp(allAreas);
        
        m = sum(allAreas) / (3*numRegions);

        %fprintf("%.2f%\n", m);

        if m < 100
            m = 100;
        elseif m > 1000
            m = 1000;
        end

        [s, idx] = sort(allAreas,'descend');
        numRegions = nnz(s > m);
    end

    K = zeros(size(BW),'uint8');
    counts = zeros(13,1,'double');

    for i=1:numRegions
        full_mask = labels == idx(i);
        mask = bwopen(bwclose(full_mask,se),se);

        data = region_descriptors(I, mask)';
        ndata = normalize_region_descriptors(data);

        [C,~] = leaf_classifier.predict(ndata);

        %conf = soft_max(margins);

        %v = soft_max(margins) > 0.16;

        %if nnz(v) == 0
        %    C = 13;
        %end

        CMASK = full_mask * C;

        %figure_maximized; timagesc(CMASK, classes(C)); colorbar;

        K = K + uint8(CMASK);
        counts(C) = counts(C) + 1;
    end
end
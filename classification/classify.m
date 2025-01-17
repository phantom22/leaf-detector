function [K,counts] = classify(I,BW,se)
    %classes = ["A","B","C","D","E","F","G","H","I","L","M","N"];
    leaf_classifier = load_leaf_classifier();
    [labels, numRegions] = bwlabel(BW);
    idx = 1:numRegions;
    if numRegions ~= 1
        props = regionprops(labels, 'Area');
        allAreas = [props.Area];
        m = sum(allAreas) / (2*numRegions);
        if m < 100
            m = 100;
        end
        [s, idx] = sort(allAreas,'descend');
        numRegions = nnz(s > m);
    end

    K = zeros(size(BW),'uint8');
    counts = zeros(12,1,'double');

    for i=1:numRegions
        full_mask = labels == idx(i);
        mask = bwopen(bwclose(full_mask,se),se);

        data = double(extract_classification_data(I, mask)');
        C = leaf_classifier.predictFcn(data);

        CMASK = full_mask * C;

        %figure_maximized; timagesc(CMASK, classes(C)); colorbar;

        K = K + uint8(CMASK);
        counts(C) = counts(C) + 1;
    end
end
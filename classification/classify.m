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

        [C,margins] = leaf_classifier.predict(ndata);

        conf = soft_max(margins)

        no_strong_conf = nnz(conf > 0.1667) == 0; % 2/12
        sorted_conf = sort(conf, 'descend');

        top_diff = sorted_conf(1) - sorted_conf(2)

        no_strong_lead = top_diff < 0.0207; % 1/(12*4)

        tie_lead = top_diff < 0.0139; % 1/(12*6)

        disp([no_strong_lead, no_strong_conf, tie_lead])

        if no_strong_conf && no_strong_lead || tie_lead % no_strong_conf for [0.0709 0.0834 0.0457 0.0988 0.0890 0.0482 0.0874 0.0823 0.1104 0.0420 0.0857]
            C = 13;
        end

        CMASK = full_mask * C;

        %figure_maximized; timagesc(CMASK, classes(C)); colorbar;

        K = K + uint8(CMASK);
        counts(C) = counts(C) + 1;
    end
end
function [K,counts] = classify(I,BW,se)
    % I = whitebalance(I);

    classifiers = load_leaf_classifier();
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

        [P, margins] = cellfun(@(c) c.predict(ndata), classifiers, 'UniformOutput', false);

        P = cell2mat(P);
        margins = soft_max(cell2mat(margins));

        cidx = find(P);

        if isscalar(cidx)
            C = cidx(1)
            conf = margins(cidx, 2)
        else
            [conf, C] = max(margins(:,2))
        end

        if conf < 0.6
            C = 13;
        end

        % if C == 0
        %     C = 13;
        % end

        CMASK = full_mask * C;

        %figure_maximized; timagesc(CMASK, classes(C)); colorbar;

        K = K + uint8(CMASK);
        counts(C) = counts(C) + 1;
    end
end
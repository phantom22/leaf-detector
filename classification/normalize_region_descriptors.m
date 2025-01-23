function [data,min_bounds,max_bounds] = normalize_region_descriptors(data, for_training, ignore_columns)
    arguments
        data;
        for_training = false;
        ignore_columns = [];
    end

    if ~for_training
        [~, min_bounds, max_bounds] = load_leaf_classifier;
        data = (data - min_bounds) ./ (max_bounds - min_bounds);
        return;
    end

    cropped = data(:,1:end-1);
    min_bounds = min(cropped);
    max_bounds = max(cropped);

    l = length(ignore_columns);
    for i=1:l
        cind = ignore_columns(i);
        min_bounds(cind) = 0;
        max_bounds(cind) = 1;
    end

    data(:,1:end-1) = (cropped - min_bounds) ./ (max_bounds - min_bounds);
end
function [data,min_bounds,max_bounds] = normalize_region_descriptors(data, for_training)
    arguments
        data;
        for_training = false;
    end

    if ~for_training
        [min_bounds, max_bounds] = load_leaf_classification_bounds;
        data = (data - min_bounds) ./ (max_bounds - min_bounds);
        return;
    end

    cropped = data(:,1:end-1);
    min_bounds = min(cropped);
    max_bounds = max(cropped);
    data(:,1:end-1) = (cropped - min_bounds) ./ (max_bounds - min_bounds);
end
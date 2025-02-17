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

    num_features = size(data,2) - 1;

    cropped = data(:,1:num_features);
    min_bounds = min(cropped);
    max_bounds = max(cropped);
   
    l = length(ignore_columns);

    if nnz(isnan(cropped)) ~= 0
        for i=1:num_features
            count = nnz(isnan(cropped(:,i)));
            if count ~= 0
                fprintf("The feature #%d has %d NaN entries!\n", i, count);
            end
        end
    end

    if l > num_features
        fprintf("ignore_columns exceed the actual count of features!\n");
        l = num_features;
    end

    for i=1:l
        cind = ignore_columns(i);
        min_bounds(cind) = 0;
        max_bounds(cind) = 1;
    end

    to_fix = min_bounds == max_bounds;

    min_bounds(to_fix) = 0;
    max_bounds(to_fix) = 1;

    data(:,1:end-1) = (cropped - min_bounds) ./ (max_bounds - min_bounds);
end
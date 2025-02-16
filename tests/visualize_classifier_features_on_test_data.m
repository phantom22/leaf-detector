function visualize_classifier_features_on_test_data
    targets = ["images/Z","images/test3"];
    num_targets = length(targets);

    [num_images,paths,~] = image_paths_from_dir(targets);

    gt_data = { ...
        { ...
            {"G","G","G","D","D","D","H","H","H","E","E","E","E","I","I","I","N","N","N","L","L","L","M","M","M","M","F","F","A","A","A","B","B","B","C","C","C"}, ...
            [5 4 5 5 5 5 6 5 7 6 6 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 4 5 5 4 5 5 5 5 5 6] ...
        }, ...
        { ...
            {"C","C","C","C","C","N","N","N","N","N","N","D","D","D","D","D","L","L","L","L","L","L","G","G","G","G","M","M","M","M","M","M","H","H","H","H","F","F","F","F","F","F","F","H","H","H"}, ...
            [5 5 5 5 5 5 5 5 4 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 4 5 5 5 5 5 5 5] ...
        } ...
    };

    mapping = containers.Map(["A","B","C","D","E","F","G","H","I","L","M","N","Unknown"], [1 2 3 4 5 6 7 8 9 10 11 12 13]);

    dummy_se = strel('disk', 0);
    se = strel('disk', 3);

    full_data = {};

    for k=1:num_targets
        image_paths = paths{k};
        image_count = num_images(k);

        % test3
        if k == 2
            image_count = image_count - 7;
        end

        gt_labels = gt_data{k}{1};
        % gt_counts = gt_data{k}{2};

        figure_maximized(targets(k));
        [m,n] = calcola_ingombro_minimo_subplot(image_count);
        for i=1:image_count
            expected_label = gt_labels{i};

            im = imresizetoarea(im2double(imread(image_paths{i})), 120000);
            mask = segment(im, se);
            % K = regions 
            %  out_data = zeros(16,1,numRegions,'single');
            [K,out_data] = local_classify(im, mask, dummy_se, mapping(expected_label));

            tsubplot(m,n,i); timagesc(K, expected_label);

            full_data{end+1} = out_data;
        end
    end

    total_num_samples = sum(cellfun(@(x) size(x,3), full_data));
    num_features = size(full_data{1},1) - 1;
    flattened_matrix = zeros(total_num_samples, num_features + 1);

    total_image_count = length(full_data);

    row_idx = 1;

    for i=1:total_image_count
        current_cell = full_data{i};
        num_samples = size(current_cell, 3);

        flattened_matrix(row_idx:row_idx+num_samples-1,:) = squeeze(current_cell)';

        row_idx = row_idx + num_samples;
    end

    feature_labels = arrayfun(@(x) num2str(x), 1:num_features, 'UniformOutput', false);

    leaf_classifier = load_leaf_classifier;
    train_X = leaf_classifier.X;
    train_Y = leaf_classifier.Y;

    plot_features(train_X,train_Y,feature_labels,"Train set distribution");
    
    test_X = flattened_matrix(:,1:num_features);
    test_Y = flattened_matrix(:,num_features+1);

    plot_features(test_X,test_Y,feature_labels,"Test set distribution");
end

function [K,out_data] = local_classify(I,BW,se,expected_class)
    I = whitebalance(I);

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
    out_data = zeros(16,1,numRegions,'single');

    for i=1:numRegions
        full_mask = labels == idx(i);
        mask = bwopen(bwclose(full_mask,se),se);

        data = double(region_descriptors(I, mask))';
        out_data(:,1,i) = [normalize_region_descriptors(data), expected_class];

        %conf = soft_max(margins);

        %v = soft_max(margins) > 0.16;

        %if nnz(v) == 0
        %    C = 13;
        %end

        CMASK = full_mask * i;

        %figure_maximized; timagesc(CMASK, classes(C)); colorbar;

        K = K + uint8(CMASK);
    end
end
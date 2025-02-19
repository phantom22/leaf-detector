function acc = mainall(target, just_segmentation, display)
    arguments
        target = "images/test3";
        just_segmentation = false;
        display = true;
    end
    %close all;

    option_mapping = containers.Map(["images/Z","images/test3","images/test2","images/test4","images/A","images/B","images/C","images/D","images/E","images/F","images/G","images/H","images/I","images/L","images/M","images/N"], [1 2 2 3 4 4 4 4 4 4 4 4 4 4 4 4]);

    option = option_mapping(target);

    options = { ...
        { ... % Z
            {"G","G","G","D","D","D","H","H","H","E","E","E","E","I","I","I","N","N","N","L","L","L","M","M","M","M","F","F","A","A","A","B","B","B","C","C","C"}, ...
            [5 4 5 5 5 5 6 5 7 6 6 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 4 5 5 4 5 5 5 5 5 6] ...
        }, ...
        { ... % test2/test3
            {"C","C","C","C","C","N","N","N","N","N","N","D","D","D","D","D","L","L","L","L","L","L","G","G","G","G","M","M","M","M","M","M","H","H","H","H","F","F","F","F","F","F","F","H","H","H"}, ...
            [5 5 5 5 5 5 5 5 4 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 4 5 5 5 5 5 5 5] ...
        }, ...
        { ... % test4
            {"A","A","A","I","I","I","I","B","B","B","B","B","E","E","E","E"}, ...
            [5 5 5 5 5 5 5 5 5 5 5 4 5 5 5 5] ...
        } ...
    };

    [num_images, class_full_paths, ~] = image_paths_from_dir(target);

    if option == 4
        splits = strsplit(target, '/');
        class_label = string(splits{end});
        gt_labels = repmat(class_label, 1, num_images);
        gt_count = ones(num_images,1);
    else
        gt_labels = options{option}{1};
        gt_count = options{option}{2};

        % if target == "images/test3"
        %     num_images = num_images - 7;
        % end
    end

    mapping = containers.Map(["A","B","C","D","E","F","G","H","I","L","M","N","Unknown"], [1 2 3 4 5 6 7 8 9 10 11 12 13]);

    total_num_leafs = sum(gt_count);

    dummy_se = strel('disk', 0);
    se = strel('disk', 3);

    correct_guesses = 0;

    [m,n] = calcola_ingombro_minimo_subplot(num_images);

    tic;

    if display
        figure_maximized(get_current_model('segmentation') + " " + target);
    end

    ignore_area = 300*400;
    target_area = ignore_area;

    for i=1:num_images
        im = imresizetoarea(im2double(imread(class_full_paths{i})), target_area, ignore_area);

        mask = segment(im, se);

        if display
            tsubplot(m,n,i);
        end

        if ~just_segmentation
            [classificato,counts] = classify(im, mask, dummy_se);
            class_label = gt_labels{i};
            expected_class = mapping(class_label);
            correct_guesses = correct_guesses + counts(expected_class);
    
            if display
                visualize_classification(classificato);
            end
        elseif display
            timshow(mask);
        end

        if display
            title(gt_labels{i});
        end

        fprintf("'%s': %d/%d.\n", target, i, num_images);
    end

    toc;

    acc = correct_guesses / total_num_leafs;

    fprintf("[%s] Accuracy: %.2f%%\n", target, acc * 100);
end
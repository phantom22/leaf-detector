function mainall

    %close all;

    gt = {"G","G","G",...
        "D","D","D",...
        "H","H","H",...
        "E","E","E","E",...
        "I","I","I",...
        "N","N","N",...
        "L","L","L",...
        "M","M","M","M",...
        "F","F",...
        "A","A","A",...
        "B","B","B",...
        "C","C","C"};
    
    gt_counts = [5 4 5 5 5 5 6 5 7 6 6 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 4 5 5 4 5 5 5 5 5 6];

    mapping = containers.Map(["A","B","C","D","E","F","G","H","I","L","M","N"], [1 2 3 4 5 6 7 8 9 10 11 12]);

    total_num_leafs = sum(gt_counts);

    [num_images, class_full_paths, ~] = image_paths_from_dir("images/Z");

    [m,n] = calcola_ingombro_minimo_subplot(num_images);

    dummy_se = strel('disk', 0);
    se = strel('disk', 6);

    correct_guesses = 0;

    figure_maximized;
    for i=1:num_images
        im = im2double(imread(class_full_paths{i}));

        f = sqrt(size(im,1) * size(im,2) / (120000*4));

        im = imresize(im, size(im,1:2) / f);

        mask = segment(im, se);
        [classificato,counts] = classify(im, mask, dummy_se);

        class_label = gt{i};
        expected_class = mapping(class_label);
        correct_guesses = correct_guesses + counts(expected_class);

        tsubplot(m,n,i);
        visualize_classification(classificato);
        title(class_label);
    end

    fprintf("Accuracy: %.2f%%\n", correct_guesses / (total_num_leafs-14) * 100);
end
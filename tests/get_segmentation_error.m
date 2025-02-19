function get_segmentation_error
    targets = ["A","B","C","D","E","F","G","H","I","L","M","N"];
    num_targets = length(targets);

    [class_num_images, class_full_paths, names] = image_paths_from_dir("images/" + targets);

    tot_num_images = sum(class_num_images);

    [~, gt_full_paths, ~] = image_paths_from_dir("images/ground_truth/" + targets);

    se = strel('disk', 3);
    
    tot_tp = 0;
    tot_tn = 0;
    tot_fp = 0;
    tot_fn = 0;

    tic;

    tot_num_pixels = 300*400*tot_num_images;

    curr_im = 1;

    tic;
    for k=1:num_targets
        target = targets(k);
        figure_maximized(target);
        num_images = class_num_images(k);
        [m,n] = calcola_ingombro_minimo_subplot(num_images);

        for i=1:num_images
            im = im2double(imread(class_full_paths{k}{i}));
            gt = imread(gt_full_paths{k}{i}) > 1;
    
            mask = segment(im, se);

            [tp,tn,fp,fn] = compute_seg_error(mask, gt);
            tot_tp = tot_tp + tp;
            tot_tn = tot_tn + tn;
            tot_fp = tot_fp + fp;
            tot_fn = tot_fn + fn;
    
            tsubplot(m,n,i);
            timagesc(gt - mask, names{k}{i});

            curr_im = curr_im + 1;
        end
        elapsed = toc;
        fprintf("'%s' done (elapsed: %.0fs, ETA: %.0fs).\n", target, round(elapsed), abs(round(elapsed/(curr_im-1)*(tot_num_images - curr_im + 1))));
    end

    toc;

    acc = (tp+tn) / tot_num_pixels;

    fprintf("[%s] Accuracy: %.2f%%\n", target, acc * 100);
end
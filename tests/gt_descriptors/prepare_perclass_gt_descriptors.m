function data = prepare_perclass_gt_descriptors(target)
    arguments
        target {mustBeTextScalar};
    end

    close all;

    targets = ["A","B","C","D","E","F","G","H","I","L","M","N"];
    targets_labels = char(targets);
    
    target_class = find(targets == target);
    
    if isempty(target_class)
        error("'%s' is not a valid target!", target);
    end

    input_dirs = strcat('images\', targets); 
    gt_dirs = strcat('images\ground_truth\', targets); 
    
    num_targets = length(targets);
    
    [file_count, og_full_paths, file_names] = image_paths_from_dir(input_dirs);
    
    [~, gt_full_paths, ~] = image_paths_from_dir(gt_dirs);
    
    total_image_count = sum(file_count);
    
    i = 1;
    tic;
    
    
    for t=1:num_targets
        target_file_count = file_count(t);

        figure_maximized(targets_labels(t));
        min_grid = get_minimal_grid(file_count(t));
    
        for k=1:target_file_count
            % convert BW grayscale image to BW rgb image
            im = im2single(imread(string(og_full_paths{t}(k))));
    
            if t == target_class
                gt = single(imread(string(gt_full_paths{t}(k))) > 1);
            else
                gt = zeros(300,400,'single');
            end
        
            desc = pixel_descriptors(im); % NUM_PIXELSxNUM_F
            desc(:,15) = gt(:);
    
            if t == 1 && k == 1
                num_features = size(desc,2);
                udata = zeros(total_image_count, 300 * 400, num_features, 'single');
            end

            udata(i,:,:) = desc(:,:);

            subplot('Position', min_grid(:,k));
            timshow(reshape(udata(i,:,15),300,400), file_names{t}(k));
    
            i = i + 1;
        end
    
        elapsed = toc;
        fprintf("'%s' done (elapsed: %.0fs, ETA: %.0fs).\n", targets(t), round(elapsed), abs(round(elapsed/(i-1)*(total_image_count - i + 1))));
    end

    data = reshape(udata,[],num_features);
end
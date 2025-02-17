function data = prepare_segmentation_data(noise_strength)
    arguments
        noise_strength = 0;
    end

    fprintf("noise_strength: %.2f%%\n", noise_strength * 100);

    targets = ["A","B","C","D","E","F","G","H","I","L","M","N"];
    
    input_dirs = strcat('images\', targets); 
    gt_dirs = strcat('images\ground_truth\', targets); 
    
    num_targets = length(targets);
    
    [~, og_full_paths, ~] = image_paths_from_dir(input_dirs);
    
    [gt_file_count, gt_full_paths, ~] = image_paths_from_dir(gt_dirs);
    
    total_image_count = sum(gt_file_count);
    
    udata = zeros(total_image_count, 300 * 400, 11, 'single'); % 22 % 28
    
    i = 1;
    tic;

    
    for t=1:num_targets
        target_file_count = gt_file_count(t);
    
        for k=1:target_file_count
            % convert BW grayscale image to BW rgb image
            im = im2single(imread(string(og_full_paths{t}(k))));
            gt = single(imread(string(gt_full_paths{t}(k))) > 1);

            im = whitebalance(im);
        
            desc = pixel_descriptors(im); % NUM_PIXELSxNUM_F
            desc(:,11) = gt(:);
    
            udata(i,:,:) = desc(:,:);
    
            i = i + 1;
        end
    
        elapsed = toc;
        fprintf("'%s' done (elapsed: %.0fs, ETA: %.0fs).\n", targets(t), round(elapsed), abs(round(elapsed/(i-1)*(total_image_count - i + 1))));
    end
    
    data = reshape(udata, [], 11);

    if noise_strength ~= 0
        data_without_labels = data(:,1:end-1);
    
        data_avg = sum(data_without_labels) / size(data,1);
        noise = ((single(-1) + single(2)*rand(size(data,1), size(data,2)-1,'single')) .* noise_strength) .* data_avg;
    
        data(:,1:end-1) = data_without_labels + noise;
    end
end
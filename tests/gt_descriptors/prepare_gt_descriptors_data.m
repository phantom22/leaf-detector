targets = ["A","B","C","D","E","F","G","H","I","L","M","N"];

input_dirs = strcat('images\', targets); 
gt_dirs = strcat('images\ground_truth\', targets); 

num_targets = length(targets);

[file_count, og_full_paths, file_names] = image_paths_from_dir(input_dirs);

[~, gt_full_paths, ~] = image_paths_from_dir(gt_dirs);

total_image_count = sum(file_count);

udata = cell(total_image_count,1); % to store superpixel collections (cell arrays): NUM_IMxNUM_SPx(NUM_F+1)

i = 1;
tic;

total_superpixel_count = 0;

for t=1:num_targets
    target_file_count = file_count(t);

    for k=1:target_file_count
        % convert BW grayscale image to BW rgb image
        im = im2single(imread(string(og_full_paths{t}(k))));
        gt_rgb = repmat(im2double(imread(string(gt_full_paths{t}(k)))), [1 1 3]);
    
        desc = gt_descriptors_without_gt_mask(im, gt_rgb); % NUM_SPxNUM_F

        total_superpixel_count = total_superpixel_count + desc.num_superpixels;
        descriptors = desc.descriptors; % NUM_SP

        mask_avg = desc.mask_avg;

        descriptors(:,11) = mask_avg;

        udata{i} = descriptors;
    
        i = i + 1;
    end

    elapsed = toc;
    fprintf("'%s' done (elapsed: %.0fs, ETA: %.0fs).\n", targets(t), round(elapsed), abs(round(elapsed/(i-1)*(total_image_count - i + 1))));
end

data = cell2mat(udata);

dirtiness = data(:,11);
[~,idx] = sort(dirtiness);

sorteddata = data(idx,:);

sorteddata(:,11) = round(sorteddata(:,11));
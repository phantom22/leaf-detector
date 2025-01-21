function [data,min_bounds,max_bounds] = prepare_classification_data(class_folders)
    arguments
        class_folders {mustBeText} = ["A","B","C","D","E","F","G","H","I","L","M","N"];
    end
    
    close all;
    num_classes = length(class_folders);
    
    % ["images\A", "images\B", ...]
    input_dirs = strcat('images\', class_folders);
    gt_dirs = strcat('images\ground_truth\', class_folders);
    
    [class_num_images, class_full_paths, ~] = image_paths_from_dir(input_dirs);
    [~, gt_full_paths, ~] = image_paths_from_dir(gt_dirs);
    
    tot_num_images = sum(class_num_images);

    se = strel('disk', 5);

    pos = 1;

    tic;
    for i=1:num_classes
        num_images = class_num_images(i);
        for k=1:num_images
            if num_classes == 1
                im_path = class_full_paths{k};
                gt_path = gt_full_paths{k};
            else
                im_path = class_full_paths{i}{k};
                gt_path = gt_full_paths{i}{k};
            end

            im = im2single(imread(im_path));

            %gt = bwopen(bwclose(imread(gt_path) > 1, se), se);
            %K = gt;

            K = segment(im, se);

            [labeledImage, numRegions] = bwlabel(K);
            if numRegions ~= 1
                props = regionprops(labeledImage, 'Area');
                allAreas = [props.Area];
                [~, maxIndex] = max(allAreas);
                K = (labeledImage == maxIndex);
            end

            if pos == 1
                v = region_descriptors(im, K);
                num_features = size(v, 1);
                data = zeros(tot_num_images, num_features + 1);
                data(pos, 1:num_features) = v;
                data(pos, num_features + 1) = i;
            else
                data(pos,1:num_features) = region_descriptors(im, K);
                data(pos,num_features + 1) = i;
            end

            pos = pos + 1;
        end
        fprintf("'%s' done \n", class_folders(i));
    end
    [data,min_bounds,max_bounds] = normalize_region_descriptors(data, true);
end
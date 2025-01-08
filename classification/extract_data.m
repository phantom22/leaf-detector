function [data, labels]=extract_data(class_folders,save)
    arguments
        class_folders {mustBeText} = ["A","B","C","D","E","F","G","H","I","L","M","N"];
        save=false;
    end
    
    close all;
    num_classes = length(class_folders);
    
    % ["images\A", "images\B", ...]
    input_dirs = strcat('images\', class_folders); 
    % ["images\ground_truth\A", "images\ground_truth\B", ...]
    gt_dirs = strcat('images\ground_truth\', class_folders); 
    
    [class_num_images, class_full_paths, class_im_names] = image_paths_from_dir(input_dirs);
    [~, gt_full_paths, image_name] = image_paths_from_dir(gt_dirs);
    
    tot_num_images = sum(class_num_images);
    
    data = zeros(tot_num_images,4);
    labels = zeros(tot_num_images,1);
    se=strel("disk",5);
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

            im = im2double(imread(im_path));
            ground_truth = extract_labels(im,se);
            % ground_truth = imread(gt_path) > 1; % 1 perché con zero crea artefatti.
            [labeledImage, numRegions] = bwlabel(ground_truth);
            props = regionprops(labeledImage, 'Area');
            allAreas = [props.Area];
            [~, maxIndex] = max(allAreas);
            ground_truth = (labeledImage == maxIndex);
            data(pos,1:4)=compute_classification(im,ground_truth);
            labels(pos)=i;
            pos=pos+1;
        end
        fprintf("'%s' done \n", i);
    end
 
end
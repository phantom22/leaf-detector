function [data, labels]=prepare_classification_data(class_folders,save)
    arguments
        class_folders {mustBeText} = ["A","B","C","D","E","F","G","H","I","L","M","N"];
        save=false;
    end
    
    close all;
    num_classes = length(class_folders);
    
    % ["images\A", "images\B", ...]
    input_dirs = strcat('images\', class_folders);  
    
    [class_num_images, class_full_paths, ~] = image_paths_from_dir(input_dirs);
    
    tot_num_images = sum(class_num_images);
    
    data = zeros(tot_num_images,65);
    labels = zeros(tot_num_images,1);
    se=strel("disk",5);
    pos = 1;
    
    tic;
    for i=1:num_classes
        num_images = class_num_images(i);
        for k=1:num_images
            if num_classes == 1
                im_path = class_full_paths{k};
            else
                im_path = class_full_paths{i}{k};
            end

            im = im2single(imread(im_path));
            K = extract_labels(im,se);

            [labeledImage, numRegions] = bwlabel(K);
            if numRegions ~= 1
                %fprintf("%s-%d\n",class_full_paths{i}{k},numRegions);
                %figure_maximized(class_full_paths{i}{k});
                %timagesc(labeledImage,num2str(numRegions));
                props = regionprops(labeledImage, 'Area');
                allAreas = [props.Area];
                [~, maxIndex] = max(allAreas);
                K = (labeledImage == maxIndex);
            end

            data(pos,:) = extract_classification_data(im,K);

            %if k>1
            %    data(pos,:) = align_second_signal(base_signal, data(pos,:));
            %else
            %    base_signal = data(pos,:);
            %end

            labels(pos,1)=i;
            pos=pos+1;
        end
        fprintf("'%s' done \n", class_folders(i));
    end
 
end
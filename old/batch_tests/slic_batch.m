function [data,num_images,max_num_superpixels] = slic_batch(num_superpixels,compactness,input_dir)
    arguments
        num_superpixels = 450;
        compactness = 10;
        input_dir = 'images/C';
    end
    close all;

    [num_images,images,~] = image_paths_from_dir(input_dir);
    
    descriptors = cell(num_images, 1);

    max_num_superpixels = -inf;
    
    tic;
    for k=1:num_images
        im = imread(images{k});
        desc = seg_descriptors(im, num_superpixels, compactness);  % num_superpixels x 4

        if max_num_superpixels < desc.num_superpixels
            max_num_superpixels = desc.num_superpixels;
        end

        d = desc.descriptors;

        descriptors{k} = d; % num_superpixels x 4
    end

    data = zeros(4, max_num_superpixels, num_images, 'single');
    for k=1:num_images
        d = descriptors{1};
        num_superpixels = size(d,1);
        data(:,1:num_superpixels,k) = d';
    end

    elapsed = toc;
    fprintf("Elapsed time is %ss (%s per image on average).\n", num2str(elapsed), num2str(elapsed/num_images));
end
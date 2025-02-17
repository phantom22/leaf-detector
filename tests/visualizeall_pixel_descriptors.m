function visualizeall_pixel_descriptors(target)
    [num_images,full_paths,~] = image_paths_from_dir(target);

    for i=1:num_images
        visualize_pixel_descriptors(full_paths{i});
    end
end
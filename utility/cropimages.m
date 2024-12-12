function cropimages(from, to, target_width, target_height)
    arguments
        from;
        to;
        target_width = 400;
        target_height = 300;
    end
    
    if ~exist(from, 'dir')
        error('non existent directory passed as input folder.');
    elseif strcmp(from,to)
        error('the otput folder cannot be equal to the input folder.');
    end
    
    images = dir(fullfile(from, '*.jpg'));
    images = images(~[images.isdir]);
    num_images = length(images);
    
    if ~exist(to, 'dir')
        mkdir(to);
    else
        disp('the output folder already exists!');
        user_input = input('Override folder? (Y/N): ', 's');
        if ~ismember(user_input, {'Y', 'y'})
            disp('operation aborted.');
            return;
        end
    end
    
    target_dir = dir(fullfile(to)).folder;

    for k=1:num_images
        fname = images(k).name;
        imwrite(imresize((fullfile(from,fname)),[target_height,target_width]), fullfile(target_dir, strcat(int2str(k),'.jpg')));
        fprintf("%d/%d '%s' done.\n", k, num_images, fname);
    end
end

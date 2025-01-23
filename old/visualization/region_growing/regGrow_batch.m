function non_bg = regGrow_batch(input_dir)
    arguments
        input_dir = "images/D";
    end
    close all;

    [num_images,images,fnames] = image_paths_from_dir(input_dir);

    og_images = zeros(300, 400, 3, num_images, 'single');
    non_bg = zeros(300, 400, num_images, 'single');

    rg = regGrow();

    ax_positions = get_minimal_grid(num_images);
    
    tic;
    for k=1:num_images
        im = im2single(imread(images{k}));
        og_images(:,:,:,k) = im;

        ycbcr = rgb2ycbcr(im);

        non_bg(:,:,k) = rg.segment(ycbcr(:,:,2), [10 10], 0.045, inf, false);
    end
    elapsed = toc;
    fprintf("Elapsed time is %ss (%s per image on average).\n", num2str(elapsed), num2str(elapsed/num_images));
    
    figure_maximized("'",input_dir,"' clustered");
    for k=1:num_images
        fname = fnames{k};

        subplot('Position',ax_positions(:,k));
        timagesc(non_bg(:,:,k), fname);
    end

    figure_maximized("'",input_dir,"' original");
    for k=1:num_images
        subplot('Position',ax_positions(:,k));
        timshow(og_images(:,:,:,k), fnames{k});
    end
end
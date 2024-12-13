function non_bg = regGrow_batch(input_dir)
    arguments
        input_dir = 'images/E';
    end
    close all;

    [num_images,images,fnames] = image_paths_from_dir(input_dir);

    og_images = zeros(300, 400, 3, num_images, 'single');
    non_bg = zeros(300, 400, num_images, 'single');

    rg = regGrow();
    
    tic;
    for k=1:num_images
        im = im2single(imread(images{k}));
        og_images(:,:,:,k) = im;

        ycbcr = rgb2ycbcr(im);

        non_bg(:,:,k) = rg.segment(ycbcr(:,:,2), [10 10], 0.04, inf, false);
    end
    elapsed = toc;
    fprintf("Elapsed time is %ss (%s per image on average).\n", num2str(elapsed), num2str(elapsed/num_images));

    subplot_rows = ceil(num_images/4);
    
    f1 = figure;
    f1.WindowState = "maximized";
    f1.NumberTitle = 'off';
    f1.Name = strcat("'",input_dir,"' clustered");
    for k=1:num_images
        fname = fnames{k};
        subplot(subplot_rows,4,k); imagesc(non_bg(:,:,k)); colormap(jet); axis image; axis off; title(fname);
        %fprintf("%d/%d '%s' done.\n", k, num_images, fname);
    end

    f2 = figure;
    f2.WindowState = "maximized";
    f2.NumberTitle = 'off';
    f2.Name = strcat("'",input_dir,"' original");
    for k=1:num_images
        subplot(subplot_rows,4,k); imshow(og_images(:,:,:,k)); title(fnames{k});
        %fprintf("%d/%d '%s' done.\n", k, num_images, fname);
    end
end
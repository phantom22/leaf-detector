function mask_averages = get_superpixel_dirtiness(target,display)
    arguments
        target {mustBeText};
        display = false;
    end
    [file_count, og_full_paths, file_names] = image_paths_from_dir("images/"+target);
    gt_full_paths =  strcat("images/ground_truth/" + target + "/", file_names);
    
    if display
        mingrid = get_minimal_grid(file_count);
        figure_maximized("'",target,"' class");
    end
    
    % for checking how clean/dirty are the superpixels
    mask_averages = zeros(file_count, 4); % min max avg dirty_sp_pct
    
    for k=1:file_count
        % convert BW grayscale image to BW rgb image
        im = im2single(imread(og_full_paths{k}));
        gt_rgb = repmat(im2double(imread(gt_full_paths{k})), [1 1 3]);

        tic;
        desc = gt_descriptors_without_gt_mask(im, gt_rgb);
        toc;

        ma = desc.mask_avg;
        ma_dirty = ma(ma ~= 0.0 & ma ~= 1.0); % all entries that are not either 100% leaf or 100% bg
        ma_deltas = [ma_dirty(ma_dirty <= 0.5); 1 - ma_dirty(ma_dirty > 0.5)];
    
        sp = desc.superpixels;
        num_sp = desc.num_superpixels;
        num_dirty_sp = length(ma_deltas);

        ma_min = min(ma_deltas);
        ma_max = max(ma_deltas);
        ma_avg = sum(ma_deltas) / num_dirty_sp;

        % disp([ num_sp num_dirty_sp num_dirty_sp/num_sp ]);
    
        mask_averages(k,:) = [ma_min ma_max ma_avg num_dirty_sp/num_sp];
    
        if display
            subplot('Position', mingrid(:,k));
            timagesc(ma(sp));
        end
    end

    fprintf("[class '%s'] min:%.5f%% max:%.5f%% avg:%.5f%% avg_pct_dirty_sp:%.3f%%\n", ...
        target, ...
        sum(mask_averages(:,1)) / file_count * 100, ...
        sum(mask_averages(:,2)) / file_count * 100, ...
        sum(mask_averages(:,3)) / file_count * 100, ...
        sum(mask_averages(:,4)) / file_count * 100);
end
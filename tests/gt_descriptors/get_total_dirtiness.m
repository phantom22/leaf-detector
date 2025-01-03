function get_total_dirtiness
    targets = ["A","B","C","D","E","F","G","H","I","L","M","N"];

    min_sum = 0;
    max_sum = 0;
    avg_sum = 0;
    avg_pct_dirt_sp_sum = 0;
    total_sample_count = 0;

    for t=1:length(targets)
        mask_averages = get_superpixel_dirtiness(targets(t),true);
        sample_count = size(mask_averages, 1);

        min_sum = min_sum + sum(mask_averages(:,1));
        max_sum = max_sum + sum(mask_averages(:,2));
        avg_sum = avg_sum + sum(mask_averages(:,3));
        avg_pct_dirt_sp_sum = avg_pct_dirt_sp_sum + sum(mask_averages(:,4));

        total_sample_count = total_sample_count + sample_count;
    end

    fprintf("[total data] min:%.5f%% max:%.5f%% avg:%.5f%% avg_pct_dirty_sp:%.3f%%\n", ...
        min_sum / total_sample_count * 100, ...
        max_sum / total_sample_count * 100, ...
        avg_sum / total_sample_count * 100, ...
        avg_pct_dirt_sp_sum / total_sample_count * 100);
end
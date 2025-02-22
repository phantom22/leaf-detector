function get_all_data()
    %train_acc = get_classification_error * 100;

    scales = 4;
    num_scales = length(scales);

    targets = ["images/Z", "images/test2", "images/test3", "images/test4"];
    num_targets = length(targets);

    test_precision = zeros(num_scales, num_targets, 1);

    tot_leafs = 688;
    target_leaf_count = [188 193 228 79];

    weights = target_leaf_count / tot_leafs;

    tot_tp = 0;
    tot_fp = 0;
    tot_fn = 0;

    for s=1:num_scales
        for t=1:num_targets
            [acc, tp, fp, fn] = mainall(targets(t), scales(s));
            acc = acc * 100;

            tot_tp = tot_tp + tp;
            tot_fp = tot_fp + fp;
            tot_fn = tot_fn + fn;

            test_precision(s, t, 1) = acc;
        end
    end

    tot_acc = tot_tp / sum([tot_tp tot_fp tot_fn]);
    prec = tot_tp / (tot_tp + tot_fp);
    rec = tot_tp / (tot_tp + tot_fn);

    weighted_pct = sum(weights .* test_precision, 2);
    uniform_pct = sum(test_precision, 2) / num_targets;

    fprintf("accuracy: %.2f%", weighted_pct)

    T = table("4x", test_precision(:,1,1), test_precision(:,2,1), test_precision(:,3,1), test_precision(:,4,1), uniform_pct, weighted_pct,...
        'VariableNames', {'Scale','images/Z','images/test2','images/test3','images/test4','uniform %','weighted %'});

    disp(T);
end
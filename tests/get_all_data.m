function get_all_data()
    train_acc = get_classification_error * 100;

    scales = [1 4 8];
    num_scales = length(scales);

    targets = ["images/Z", "images/test2", "images/test3", "images/test4"];
    num_targets = length(targets);

    test_precision = zeros(num_scales, num_targets, 1);

    tot_leafs = 688;
    target_leaf_count = [188 193 228 79];

    weights = target_leaf_count / tot_leafs;

    for s=1:num_scales
        for t=1:num_targets
            test_precision(s, t, 1) = mainall(targets(t), scales(s)) * 100;
        end
    end

    weighted_pct = sum(weights .* test_precision, 2);
    uniform_pct = sum(test_precision, 2) / num_targets;

    T = table(["1x";"4x";"8x"], test_precision(:,1,1), test_precision(:,2,1), test_precision(:,3,1), test_precision(:,4,1), uniform_pct, weighted_pct,...
        'VariableNames', {'Scale','images/Z','images/test2','images/test3','images/test4','uniform %','weighted %'});

    disp(T);
end
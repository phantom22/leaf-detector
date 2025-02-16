function get_classification_error
    target = ["images/A","images/B","images/C","images/D","images/E","images/F","images/G","images/H","images/I","images/L","images/M","images/N"];
    num_targets = length(target);

    acc_sum = 0;

    for i=1:num_targets
        acc_sum = acc_sum + mainall(target(i), false, false);
    end

    fprintf("[total] Accuracy: %.2f%%\n", acc_sum / num_targets * 100);
end
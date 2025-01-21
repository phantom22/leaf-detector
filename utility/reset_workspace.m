if ~ismember(input('reset workspace? (Y/N): ', 's'), {'Y', 'y'})
    disp('didn''t remove old models from workspace.');
    return;
else
    clear pixel_classifier;
    clear leaf_classifier;
    clear leaf_classifier_min_bounds;
    clear leaf_classifier_min_bounds;
    disp('removed old models from workspace.');
end
function reset_workspace
    evalin('base', 'clear pixel_classifier');
    evalin('base', 'clear leaf_classifier');
    evalin('base', 'clear leaf_classifier_min_bounds');
    evalin('base', 'clear leaf_classifier_max_bounds');
    disp('removed old models from workspace.');
end
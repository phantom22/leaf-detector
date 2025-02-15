function [leaf_classifier,min_bounds,max_bounds] = load_leaf_classifier
    if evalin('base',"exist('leaf_classifier','var')") &&  evalin('base',"exist('leaf_classifier_min_bounds','var')") && evalin('base',"exist('leaf_classifier_max_bounds','var')")
        leaf_classifier = evalin('base', 'leaf_classifier');
        min_bounds = evalin('base', 'leaf_classifier_min_bounds');
        max_bounds = evalin('base', 'leaf_classifier_max_bounds');
    else
        target_model = get_current_model('classification');
        fprintf("loaded '%s' classification model.\n", target_model);

        load(target_model, 'leaf_classifier', 'min_bounds', 'max_bounds');
        assignin('base', 'leaf_classifier', leaf_classifier);
        assignin('base', 'leaf_classifier_min_bounds', min_bounds);
        assignin('base', 'leaf_classifier_max_bounds', max_bounds);
    end
end
function [classifiers,min_bounds,max_bounds] = load_leaf_classifier
    if evalin('base',"exist('classifiers','var') & exist('leaf_classifier_min_bounds','var') & exist('leaf_classifier_max_bounds','var')")
        classifiers = evalin('base', 'classifiers');
        min_bounds = evalin('base', 'leaf_classifier_min_bounds');
        max_bounds = evalin('base', 'leaf_classifier_max_bounds');
    else
        target_model = get_current_model('classification');

        load(target_model, 'classifiers', 'min_bounds', 'max_bounds');

        assignin('base', 'classifiers', classifiers);
        assignin('base', 'leaf_classifier_min_bounds', min_bounds);
        assignin('base', 'leaf_classifier_max_bounds', max_bounds);
    end
end
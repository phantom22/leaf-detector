function [min_bounds, max_bounds] = load_leaf_classification_bounds()
    if exist('leaf_classifier_min_bounds','var') && exist('leaf_classifier_max_bounds','var')
        min_bounds = evalin('base', 'leaf_classifier_min_bounds');
        max_bounds = evalin('base', 'leaf_classifier_max_bounds');
        return;
    end

    load('models\20-feature-classifier.mat', 'min_bounds', 'max_bounds');
    assignin('base', 'leaf_classifier_min_bounds', min_bounds);
    assignin('base', 'leaf_classifier_max_bounds', max_bounds);
end
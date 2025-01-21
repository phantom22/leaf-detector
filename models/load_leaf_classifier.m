function [leaf_classifier,min_bounds,max_bounds] = load_leaf_classifier
    if evalin('base',"exist('leaf_classifier','var')") && exist('leaf_classifier_min_bounds','var') && exist('leaf_classifier_max_bounds','var')
        leaf_classifier = evalin('base', 'leaf_classifier');
        min_bounds = evalin('base', 'leaf_classifier_min_bounds');
        max_bounds = evalin('base', 'leaf_classifier_max_bounds');
    else
        load('models/b_classifier.mat', 'leaf_classifier', 'min_bounds', 'max_bounds');
        assignin('base', 'leaf_classifier', leaf_classifier);
        assignin('base', 'leaf_classifier_min_bounds', min_bounds);
        assignin('base', 'leaf_classifier_max_bounds', max_bounds);
    end
end
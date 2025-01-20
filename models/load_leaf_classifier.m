function leaf_classifier = load_leaf_classifier
    if evalin('base',"exist('leaf_classifier','var')")
        leaf_classifier = evalin('base', 'leaf_classifier');
    else
        load('models/leaf_classification_conMomenti.mat', 'leaf_classifier');
        assignin('base', 'leaf_classifier', leaf_classifier);
    end
end
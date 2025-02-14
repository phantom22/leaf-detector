function visualize_classifier_features(classifier)

    X = classifier.X;
    num_features = size(X,2);
    Y = classifier.Y;

    feature_labels = arrayfun(@(x) num2str(x), 1:num_features, 'UniformOutput', false);

    plot_features(X,Y,feature_labels);
end
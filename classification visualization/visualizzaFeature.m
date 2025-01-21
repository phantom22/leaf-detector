% Dati di esempio
data = prepare_classification_data();

feature_labels = arrayfun(@(x) num2str(x), 1:16, 'UniformOutput', false);

vvvisualize(data,labels,feature_labels);
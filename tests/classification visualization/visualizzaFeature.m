% Dati di esempio
data = prepare_classification_data();

feature_labels = arrayfun(@(x) num2str(x), 1:24, 'UniformOutput', false);

vvvisualize(data,data(:,25),feature_labels);
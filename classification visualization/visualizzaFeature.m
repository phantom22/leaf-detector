% Dati di esempio
[data,labels]=prepare_classification_data();

%feature_labels = arrayfun(@(x) num2str(x), 1:65, 'UniformOutput', false);

data(:,end) = normalize(data(:,end), 'norm');

%vvvisualize(data,labels,feature_labels);

data(:,end+1) = labels(:);
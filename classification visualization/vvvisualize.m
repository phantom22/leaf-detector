function vvvisualize(data, labels, data_labels)

    unique_labels = unique(labels);
    colors = lines(length(unique_labels));

    num_features = size(data,2);
    for f=1:num_features
        % Plot dei dati
        figure_maximized;
        hold on;
        for i = 1:length(unique_labels)
            % Seleziona i punti con l'etichetta corrente
            idx = labels == unique_labels(i);
            scatter(i * ones(sum(idx), 1), data(idx,f), 50, colors(i, :), 'filled', 'DisplayName', ['Label ' num2str(unique_labels(i))]);
        end
        hold off;
        
        % Aggiunta di etichette, titolo e legenda
        xlabel('Classe (Distribuzione)');
        ylabel('Feature');
        title(data_labels{f});
    end
end
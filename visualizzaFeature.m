% Dati di esempio
[x,labels]=extract_data();

% Creazione della mappa colori
unique_labels = unique(labels);
colors = lines(length(unique_labels)); % Colori distinti per ogni etichetta

for feature=1:size(x,2)

    % Plot dei dati
    figure;
    hold on;
    for i = 1:length(unique_labels)
        % Seleziona i punti con l'etichetta corrente
        idx = labels == unique_labels(i);
        scatter(i * ones(sum(idx), 1), x(idx,feature), 50, colors(i, :), 'filled', 'DisplayName', ['Label ' num2str(unique_labels(i))]);
    end
    hold off;
    
    % Aggiunta di etichette, titolo e legenda
    xlabel('Feature');
    ylabel('Classe (Distribuzione)');
    title('Feature 1 con punti colorati in base alle etichette');
end
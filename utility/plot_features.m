function plot_features(data, labels, data_labels, window_title)
    arguments
        data 
        labels 
        data_labels 
        window_title = "";
    end

    unique_labels = unique(labels);
    colors = lines(length(unique_labels));

    num_features = size(data,2);
    
    [m,n] = calcola_ingombro_minimo_subplot(num_features);

    figure_maximized(window_title);
    for f=1:num_features
        % Plot dei dati
        tsubplot(m,n,f);
        
        hold on;
        for i = 1:length(unique_labels)
            % Seleziona i punti con l'etichetta corrente
            idx = labels == unique_labels(i);
            Y = data(idx,f);
            scatter_obj = scatter(i * ones(sum(idx), 1), Y, 20, colors(i, :), 'filled', 'DisplayName', ['Label ' num2str(unique_labels(i))]);
            scatter_obj.UserData = 1: length(Y);
        end
        hold off;

        dcm = datacursormode(gcf);
        datacursormode on;
        set(dcm, 'UpdateFcn', @(obj, event_obj) simpleTooltip(event_obj));
        label = string(data_labels{f});
        title(label);
    end
end

function txt = simpleTooltip(event_obj)
    % Get scatter object and its UserData
    target = get(event_obj, 'Target');
    extra_info = target.UserData;

    % Get the position of the selected point
    pos = get(event_obj, 'Position');  % [X, Y]
    idx = find(abs(pos(2) - get(target, 'YData')) < 1e-10, 1);  % Match Y position

    % Display X, Y, and additional info
    txt = {
        ['X: ', num2str(pos(1))], ...
        ['Y: ', num2str(pos(2))], ...
        ['Extra Info: ', num2str(extra_info(idx))]
    };
end
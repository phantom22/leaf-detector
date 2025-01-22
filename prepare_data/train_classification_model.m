function train_classification_model(model_name, standardize)
    arguments
        model_name {mustBeTextScalar};
        standardize;
    end

    [folderPath, model_name, ext] = fileparts(model_name);

    if folderPath ~= "" || ext ~= ""
        error("just specify the name of the model.");
    end

    target_file = "models/" + model_name + ".mat";
    if exist(target_file, 'file') && ~ismember(input(sprintf('a model with the name "%s" already exists, override it? (Y/N): ', model_name), 's'), {'Y', 'y'})
        disp('aborted training.');
        return;
    end

    [data, min_bounds, max_bounds] = prepare_classification_data;

    c = corr(data(:,1:end-1));

    analyze_correlation(c);
    
    leaf_classifier = fitcknn(data(:,1:end-1), data(:,end), ...
        'OptimizeHyperparameters', {'NumNeighbors', 'Distance'}, ... % Optimize these
        'Standardize', standardize, ...
        'HyperparameterOptimizationOptions', struct( ...
            'AcquisitionFunctionName', 'expected-improvement-plus', ... % Optimization strategy
            'UseParallel', true, ...
            'ShowPlots', false)); % Optionally use parallelization
    
    save(target_file, 'leaf_classifier', 'min_bounds', 'max_bounds');

    if ~ismember(input('reset workspace? (Y/N): ', 's'), {'Y', 'y'})
        disp('didn''t remove old models from workspace.');
        return;
    else
        reset_workspace;
    end

    if ismember(input('change current working classifier model in "models/current_model.txt"? (Y/N): ', 's'), {'Y', 'y'})
        fileID = fopen('models/current_classifier_model.txt', 'w'); % 'w' means write mode
        fprintf(fileID, '%s', target_file);
        fclose(fileID);
    end
end
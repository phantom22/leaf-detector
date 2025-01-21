function train_classification_model(model_name)
    arguments
        model_name {mustBeTextScalar};
    end

    [data,min_bounds,max_bounds] = prepare_classification_data;
    
    leaf_classifier = fitcknn(data(:,1:end-1), data(:,end), ...
        'OptimizeHyperparameters', {'NumNeighbors', 'Distance'}, ... % Optimize these
        'Standardize', true, ...
        'HyperparameterOptimizationOptions', struct( ...
            'AcquisitionFunctionName', 'expected-improvement-plus', ... % Optimization strategy
            'UseParallel', true, ...
            'ShowPlots', false)); % Optionally use parallelization
    
    save(model_name, 'leaf_classifier', 'min_bounds', 'max_bounds');
end
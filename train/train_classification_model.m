function train_classification_model(model_name, standardize)
    arguments
        model_name {mustBeTextScalar};
        standardize;
    end

    [folderPath, model_name, ext] = fileparts(model_name);

    if folderPath ~= "" || ext ~= ""
        error("just specify the name of the model.");
    end

    target_file = "models/classification/" + model_name + ".mat";
    if exist(target_file, 'file') && ~ismember(input(sprintf('a model with the name "%s" already exists, override it? (Y/N): ', model_name), 's'), {'Y', 'y'})
        disp('aborted training.');
        return;
    end

    [data, min_bounds, max_bounds] = prepare_classification_data;

    c = corr(data(:,1:end-1));

    analyze_correlation(c);
    
    % leaf_classifier = fitcknn(data(:,1:end-1), data(:,end), ...
    %     'OptimizeHyperparameters', {'NumNeighbors', 'Distance'}, ... % Optimize these
    %     'Standardize', standardize, ...
    %     'HyperparameterOptimizationOptions', struct( ...
    %         'AcquisitionFunctionName', 'expected-improvement-plus', ... % Optimization strategy
    %         'UseParallel', true, ...
    %         'ShowPlots', false, ...
    %         'MaxObjectiveEvaluations', 50)); % Optionally use parallelization

    leaf_classifier = fitcecoc(data(:,1:end-1), data(:,end), ...
        'Learners', templateSVM('Standardize', standardize, 'KernelFunction', 'linear'), ...
        'FitPosterior', true, ...
        'OptimizeHyperparameters', {'BoxConstraint', 'KernelScale', 'KernelFunction'}, ... % Optimize these
        'HyperparameterOptimizationOptions', struct( ...
            'AcquisitionFunctionName', 'expected-improvement-plus', ... % Optimization strategy
            'UseParallel', true, ...
            'ShowPlots', false, ...
            'MaxObjectiveEvaluations', 50)); % Optionally use parallelization

    for i = 1:numel(leaf_classifier.BinaryLearners)
        if ~isempty(leaf_classifier.BinaryLearners{i}) && isa(leaf_classifier.BinaryLearners{i}, 'ClassificationSVM')
            leaf_classifier.BinaryLearners{i} = fitSVMPosterior(leaf_classifier.BinaryLearners{i});
        end
    end

    % leaf_classifier = fitcensemble(data(:,1:end-1), data(:,end), ...
    %     'OptimizeHyperparameters', {'NumLearningCycles', 'SplitCriterion', 'MaxNumSplits'}, ...
    %     'Method', 'AdaBoostM2', ...
    %     'Learners', templateTree('MinLeafSize', 2, 'MaxNumSplits', 15), ...
    %     'LearnRate', 0.95512, ...
    %     'NumLearningCycles', 100, ...
    %     'HyperparameterOptimizationOptions', struct( ...
    %          'AcquisitionFunctionName', 'expected-improvement-plus', ...
    %          'UseParallel', true, ...
    %          'ShowPlots', false, ...
    %          'MaxObjectiveEvaluations', 50));
    
    save(target_file, 'leaf_classifier', 'min_bounds', 'max_bounds');

    if ~ismember(input('load new model into workspace? (Y/N): ', 's'), {'Y', 'y'})
        disp('didn''t remove old models from workspace.');
        return;
    else
        reset_workspace;
        load_leaf_classifier;
    end

    fileID = fopen('models/current_classification_model.txt', 'r');
    current_model = fgetl(fileID);
    fclose(fileID);

    if current_model ~= target_file && ismember(input('change current working classifier model in "models/current_classification_model.txt"? (Y/N): ', 's'), {'Y', 'y'})
        fileID = fopen('models/current_classification_model.txt', 'w'); % 'w' means write mode
        fprintf(fileID, '%s', target_file);
        fclose(fileID);
    end
end
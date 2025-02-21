function [data,min_bounds,max_bounds] = train_classification_model(model_name, noise, standardize, data, min_bounds, max_bounds)
    arguments
        model_name {mustBeTextScalar};
        noise = 0;
        standardize = false;
        data = [];
        min_bounds = [];
        max_bounds = [];
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

    if isempty(data)
        [data, min_bounds, max_bounds] = prepare_classification_data(noise);
    
        c = corr(data(:,1:end-1));
    
        analyze_correlation(c);
    end

    %try
        classifiers = cell(12,1);
        for i=1:12
            tdata = data;
            tdata(tdata(:,end) ~= i,end) = 0;
            tdata(tdata(:,end) == i,end) = 1;

            classifiers{i} = fitcsvm(tdata(:,1:end-1), tdata(:,end), ...
                'KernelFunction', 'gaussian', 'BoxConstraint', 883.4, 'KernelScale', 5.2607, ...
                'OptimizeHyperparameters', {'BoxConstraint', 'KernelScale','KernelFunction'}, ...
                'HyperparameterOptimizationOptions', struct( ...
                'AcquisitionFunctionName', 'expected-improvement-plus', ... % Optimization strategy
                'UseParallel', true, ...
                'ShowPlots', false, ...
                'MaxObjectiveEvaluations', 50));

            % classifiers{i} = fitcensemble(tdata(:,1:end-1), tdata(:,end), ...
            % 'OptimizeHyperparameters', {'NumLearningCycles', 'SplitCriterion', 'MaxNumSplits', 'LearnRate', 'NumLearningCycles', 'MinLeafSize', 'MaxNumSplits'}, ...
            % 'Method', 'AdaBoostM2', ...
            % 'Learners', templateTree(), ...
            % 'HyperparameterOptimizationOptions', struct( ...
            %      'AcquisitionFunctionName', 'expected-improvement-plus', ...
            %      'UseParallel', true, ...
            %      'ShowPlots', false, ...
            %      'MaxObjectiveEvaluations', 50));

            % classifiers{i} = fitcknn(tdata(:,1:end-1), tdata(:,end), ...
            % 'OptimizeHyperparameters', {'NumNeighbors', 'Distance'}, ... % Optimize these
            % 'Standardize', standardize, ...
            % 'HyperparameterOptimizationOptions', struct( ...
            %     'AcquisitionFunctionName', 'expected-improvement-plus', ... % Optimization strategy
            %     'UseParallel', true, ...
            %     'ShowPlots', false, ...
            %     'MaxObjectiveEvaluations', 50)); % Optionally use parallelization
        end
        

        % leaf_classifier = fitcecoc(data(:,1:end-1), data(:,end), ...
        %     'Learners', templateSVM('Standardize', standardize, 'KernelFunction', 'gaussian', 'BoxConstraint', 883.4, 'KernelScale', 5.2607), ...
        %     'FitPosterior', true); %, ...
            % 'OptimizeHyperparameters', {'BoxConstraint', 'KernelScale'}, ... % Optimize these
            % 'HyperparameterOptimizationOptions', struct( ...
            %     'AcquisitionFunctionName', 'expected-improvement-plus', ... % Optimization strategy
            %     'UseParallel', true, ...
            %     'ShowPlots', false, ...
            %     'MaxObjectiveEvaluations', 50)); % Optionally use parallelization

    %catch e
    %    return;
    %end

    save(target_file, 'classifiers', 'min_bounds', 'max_bounds');

    if get_current_model('classification') ~= target_file && ismember(input('change current working classifier model in "models/current_classification_model.txt"? (Y/N): ', 's'), {'Y', 'y'})
        fileID = fopen('models/current_classification_model.txt', 'w'); % 'w' means write mode
        fprintf(fileID, '%s', target_file);
        fclose(fileID);
    end

    if ~ismember(input('load new model into workspace? (Y/N): ', 's'), {'Y', 'y'})
        disp('didn''t remove old models from workspace.');
        return;
    else
        reset_workspace;
        load_leaf_classifier;
    end
end
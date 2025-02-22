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

    extra_data = 5.5; % 400%
    train_percentages = [0.65 1 1 1 1 1 1 1 1 1 1 1];

    %try
        classifiers = cell(12,1);
        for i=1:12
            tdata = data;

            target_idx = find(tdata(:,end) == i);
            train_pct = train_percentages(i);

            if train_pct ~= 1
                total_class_size = length(target_idx);
                class_size = ceil(total_class_size * train_percentages(i));
    
                target_idx = target_idx(randperm(total_class_size, class_size));
            else
                class_size = length(target_idx);
            end

            if extra_data > 0

                other_size = max(ceil(class_size*extra_data / 10), 1);
    
                other_idx = [];
    
                p = 1;
                for j=2:12
                    if j == i
                        continue;
                    end
    
                    tidx = find(tdata(:,end) == j);
                    tdata(tidx, end) = 0;

                    how_many = min(length(tidx), other_size);

                    other_idx = [other_idx; tidx(randperm(length(tidx), how_many))];
                    p = p + other_size;
                end
    
                tdata(target_idx, end) = 1;
    
                tdata = tdata([target_idx; other_idx], :);

                classifiers{i} = fitcensemble(tdata(:,1:end-1), tdata(:,end), ...
                    'OptimizeHyperparameters', {'NumLearningCycles', 'SplitCriterion', 'MaxNumSplits', 'LearnRate', 'NumLearningCycles', 'MinLeafSize', 'MaxNumSplits'}, ...
                    'Method', 'AdaBoostM1', ...
                    'Learners', templateTree(), ...
                    'HyperparameterOptimizationOptions', struct( ...
                         'AcquisitionFunctionName', 'expected-improvement-plus', ...
                         'UseParallel', true, ...
                         'ShowPlots', false, ...
                         'MaxObjectiveEvaluations', 50));

                % classifiers{i} = fitcsvm(tdata(:,1:end-1), tdata(:,end), ...
                %     'KernelFunction', 'gaussian', 'BoxConstraint', 883.4, 'KernelScale', 5.2607); %, ...
            else
                tdata(target_idx, end) = 1;
                tdata = tdata(target_idx, :);

                classifiers{i} = fitcsvm(tdata(:,1:end-1), tdata(:,end), ...
                    'KernelFunction', 'gaussian', 'KernelScale', 5.2607);
            end
                % 'OptimizeHyperparameters', {'BoxConstraint', 'KernelScale','KernelFunction'}, ...
                % 'HyperparameterOptimizationOptions', struct( ...
                % 'AcquisitionFunctionName', 'expected-improvement-plus', ... % Optimization strategy
                % 'UseParallel', true, ...
                % 'ShowPlots', false, ...
                % 'MaxObjectiveEvaluations', 50));

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
function train_segmentation_model(model_name)
    arguments
        model_name {mustBeTextScalar};
    end

    error('usa classification learner app.');

    [folderPath, model_name, ext] = fileparts(model_name);

    if folderPath ~= "" || ext ~= ""
        error("just specify the name of the model.");
    end

    target_file = "models/segmentation/" + model_name + ".mat";
    if exist(target_file, 'file') && ~ismember(input(sprintf('a model with the name "%s" already exists, override it? (Y/N): ', model_name), 's'), {'Y', 'y'})
        disp('aborted training.');
        return;
    end

    data = prepare_segmentation_data;
    
    pixel_classifier = compact(fitctree(data(:,1:end-1), data(:,end), 'MaxNumSplits', 100));
    
    save(target_file, 'pixel_classifier');

    if ~ismember(input('load new model into workspace? (Y/N): ', 's'), {'Y', 'y'})
        disp('didn''t remove old models from workspace.');
        return;
    else
        reset_workspace;
        load_pixel_classifier;
    end

    fileID = fopen('models/current_segmentation_model.txt', 'r');
    current_model = fgetl(fileID);
    fclose(fileID);

    if current_model ~= target_file && ismember(input('change current working segmentation model in "models/current_segmentation_model.txt"? (Y/N): ', 's'), {'Y', 'y'})
        fileID = fopen('models/current_segmentation_model.txt', 'w'); % 'w' means write mode
        fprintf(fileID, '%s', target_file);
        fclose(fileID);
    end
end
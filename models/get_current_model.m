function model_name = get_current_model(which_model)
    switch which_model
        case 'segmentation'
            model_name = get_segmentation_model;
            return;
        case 'classification'
            model_name = get_classification_model;
            return;
        otherwise
            error('Specified invalid model, expected either ''segmentation'' or ''classification''.');
    end
end

function model_name = get_classification_model
    fileID = fopen('models/current_classification_model.txt', 'r');
    model_name = fgetl(fileID);
    fclose(fileID);
    return;
end

function model_name = get_segmentation_model
    fileID = fopen('models/current_segmentation_model.txt', 'r');
    model_name = fgetl(fileID);
    fclose(fileID);
    return;
end
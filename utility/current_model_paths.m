function current_model_paths
    fileID = fopen('models/current_segmentation_model.txt', 'r');
    seg_model = fgetl(fileID);
    fclose(fileID);

    fileID = fopen('models/current_classification_model.txt', 'r');
    cla_model = fgetl(fileID);
    fclose(fileID);

    fprintf(" segmentation model: '%s'.\n classification_model: '%s'\n", seg_model, cla_model);
end
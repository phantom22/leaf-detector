function pixel_classifier = load_pixel_classifier
    if evalin('base',"exist('pixel_classifier','var')")
        pixel_classifier = evalin('base', 'pixel_classifier');
    else
        fileID = fopen('models/current_segmentation_model.txt', 'r');
        target_model = fgetl(fileID);
        fclose(fileID);

        load(target_model, 'pixel_classifier');
        assignin('base', 'pixel_classifier', pixel_classifier);
    end
end
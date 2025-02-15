function pixel_classifier = load_pixel_classifier
    if evalin('base',"exist('pixel_classifier','var')")
        pixel_classifier = evalin('base', 'pixel_classifier');
    else
        target_model = get_current_model('segmentation');
        fprintf("loaded '%s' classification model.\n", target_model);

        load(target_model, 'pixel_classifier');
        assignin('base', 'pixel_classifier', pixel_classifier);
    end
end
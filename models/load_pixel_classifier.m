function pixel_classifier = load_pixel_classifier
    if evalin('base',"exist('pixel_classifier','var')")
        pixel_classifier = evalin('base', 'pixel_classifier');
    else
        load('models/optimized-pixel-classifier.mat', 'pixel_classifier');
        assignin('base', 'pixel_classifier', pixel_classifier);
    end
end
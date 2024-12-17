function main
    im = imread('images/A/7.jpg');

    desc = extract_slic_descriptors(im, 1500, 20);
    slic_kmeans(im, desc, 2, true, false);

    %disp(size(desc.descriptors))

    %in_row = reshape(desc.descriptors, [], 1);
    
    %actual_length = length(in_row);

    %expected_length = length(leaf_classificator.ClassificationTree.PredictorNames);

    %in_row = padarray(in_row, expected_length-actual_length, 'post');

    %labels = {'A','B','C','D','E'};
    %[yfit,~] = leaf_classificator.predictFcn(in_row);

    %display(labels{yfit});
end
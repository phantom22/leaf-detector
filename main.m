function main
    im = imread('images/N/11.jpg');

    desc = extract_slic_descriptors(im, 4000, 18);
    slic_kmeans(im, desc, 5, true, true);

    %disp(size(desc.descriptors))

    %in_row = reshape(desc.descriptors, [], 1);
    
    %actual_length = length(in_row);

    %expected_length = length(leaf_classificator.ClassificationTree.PredictorNames);

    %in_row = padarray(in_row, expected_length-actual_length, 'post');

    %labels = {'A','B','C','D','E'};
    %[yfit,~] = leaf_classificator.predictFcn(in_row);

    %display(labels{yfit});
end
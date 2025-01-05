[ni_a,A,~] = image_paths_from_dir('images/A');
[ni_b,B,~] = image_paths_from_dir('images/B');
[ni_c,C,~] = image_paths_from_dir('images/C');
[ni_d,D,~] = image_paths_from_dir('images/D');
[ni_e,E,~] = image_paths_from_dir('images/E');

images = [A,B,C,D,E];
expected = zeros(ni_a+ni_b+ni_c+ni_d+ni_e, 1);
offsets = cumsum([1,ni_a,ni_b,ni_c,ni_d]);
num_images = length(images);
for k=1:length(images)
    if k < offsets(2)
        label = 1;
    elseif k < offsets(3)
        label = 2;
    elseif k < offsets(4)
        label = 3;
    elseif k < offsets(5)
        label = 4;
    else
        label = 5;
    end
    expected(k) = label;
end

confmat = zeros(5,5,'single');
for k=1:length(images)
    im = imread(images{k});
    desc = seg_descriptors(im, 350, 18);
    in_row = reshape(desc.descriptors, [], 1);
    actual_length = length(in_row);
    expected_length = length(leaf_classificator.ClassificationTree.PredictorNames);
    in_row = padarray(in_row, expected_length-actual_length, 'post');
    [p,~] = leaf_classificator.predictFcn(in_row);

    e = expected(k);
    confmat(p,e) = confmat(p,e) + 1;
    fprintf("%d/%d '%s' done.\n", k, num_images, images{k});
end

% for k=1:length(images)
    % im = imread(images{k});
    % desc = seg_descriptors(im, 350, 18);
    % in_row = reshape(desc.descriptors, [], 1);
    % actual_length = length(in_row);
    % expected_length = length(leaf_classificator.ClassificationTree.PredictorNames);
    % in_row = padarray(in_row, expected_length-actual_length, 'post');
%     [p,~] = trainedModel.predictFcn(data_all(1:end-1,k)');
%     e = data_all(end,k);
%     confmat(p,e) = confmat(p,e) + 1;
%     fprintf("%d/%d '%s' done.\n", k, num_images, images{k});
% end
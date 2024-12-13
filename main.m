%function main(target)
    im = imread('images/A/5.jpg');

    desc = extract_slic_descriptors(im, 350, 18);

    in_row = reshape(desc.descriptors, [], 1);
    
    l = length(in_row);

    in_row = padarray(in_row, 1784-l, 'post');

    [yfit,scores] = leaf_classificator.predictFcn(in_row);
%end
% Correct usage: normglcm(im, num_levels, mask)
%     im: grayscale image of type single, all entries must have values in the range [0,1].
%     (optional) num_levels: specifies the dimensions of the output matrix, must be >= 2.
%     (optional) mask: it specifies the pixels to consider, must match the dimensions of im and of logical type.
%
% out_args: glcm
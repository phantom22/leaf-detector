function r = bwopen(BW, STREL)
    % r = bwopen(BW, STREL)
    %
    % STREL is assumed to be either a valid 0/1 matrix or a struct returned
    % by strel.
    if isa(STREL,'strel') 
        se = STREL.Neighborhood;
    else
        se = STREL;
    end
    r = conv2(conv2(BW, se, 'same') == nnz(se), se, 'same') > 0;
end
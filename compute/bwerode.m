function r = bwerode(BW, STREL)
    % r = bwerode(BW, STREL)
    %
    % STREL is assumed to be either a valid 0/1 matrix or a struct returned
    % by strel.
    if isa(STREL,'strel') 
        se = STREL.Neighborhood;
    else
        se = STREL;
    end
    %r = conv2(padarray(BW, floor(size(se)/2), 0, 'both'), se, 'valid') == nnz(se);
    r = conv2(BW, se, 'same') == nnz(se);
end
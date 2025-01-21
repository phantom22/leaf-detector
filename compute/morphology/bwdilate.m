function r = bwdilate(BW, STREL)
    % r = bwdilate(BW, STREL)
    %
    % STREL is assumed to be either a valid 0/1 matrix or a struct returned
    % by strel.
    if isa(STREL,'strel') 
        se = STREL.Neighborhood;
    else
        se = STREL;
    end
    r = conv2(BW, se, 'same') > 0;
end
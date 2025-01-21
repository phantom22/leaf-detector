function S = remap_set(S, mapping, title)
    l = length(S);
    fprintf("%s\n", title);
    for i = 1:l
        % Access each sub-cell array
        subArray = S{i};
        
        % Replace numerical values with labels using the mapping
        S{i} = cellfun(@(x) mapping(x), subArray, 'UniformOutput', false);

        fprintf(" - %s", strjoin(S{i}, ', '))
        fprintf(".\n");
    end
end
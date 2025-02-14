function print_set(S, mapping, title)
    l = length(S);
    if l == 0
        return;
    end

    fprintf("%s\n", title);

    for i = 1:l
        % Replace numerical values with labels using the mapping
        r = cellfun(@(x) mapping(x), S{i}, 'UniformOutput', false);

        fprintf(" - %s", strjoin(r, ', '))
        fprintf(".\n");
    end

    fprintf('\n');
end
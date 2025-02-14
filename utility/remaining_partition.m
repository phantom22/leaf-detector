function O = remaining_partition(S, max_element)
    if isempty(S)
        O = {num2cell(1:max_element)};
        return;
    end

    O = {};
    fl = [S{:}];
    for i=1:max_element
        if any(cellfun(@(x) isequal(x, i), fl))
            continue;
        end

        if isempty(O)
            O = {{}};
        end

        O{1}{end+1} = i;
    end
end
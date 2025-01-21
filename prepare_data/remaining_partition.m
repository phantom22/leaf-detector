function O = remaining_partition(S, max_element)
    O = {{}};
    fl = [S{:}];
    for i=1:max_element
        if any(cellfun(@(x) isequal(x, i), fl))
            continue;
        end
        O{1}{end+1} = i;
    end
end
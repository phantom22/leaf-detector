function i = find_set(set_collection, element)
    l = length(set_collection);
    i = 0;
    for idx=1:l
        if any(cellfun(@(x) isequal(x, element), set_collection{idx}))
            i = idx;
            return;
        end
    end
end
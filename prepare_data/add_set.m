function S = add_set(S, element_a, element_b)
    idx_a = find_set(S, element_a);
    idx_b = find_set(S, element_b);

    disp([element_a, element_b, idx_a, idx_b]);

    if idx_a == 0 && idx_b == 0
        S{end+1} = {element_a, element_b};
        fprintf('scritto in %d\n', length(S))
        disp(S{end});
    elseif idx_a ~= 0 && idx_b == 0
        S{idx_a}{end+1} = element_b;
        fprintf('scritto in %d\n', idx_a)
        disp(S{idx_a});
    elseif idx_a == 0 && idx_b ~= 0
        S{idx_b}{end+1} = element_a;
        fprintf('scritto in %d\n', idx_b)
        disp(S{idx_b});
    elseif idx_a ~= idx_b
        merged_set = unique([cell2mat(S{idx_a}), cell2mat(S{idx_b})]);
        S{idx_a} = num2cell(merged_set); % Convert back to cell array
        S(idx_b) = []; % Remove the smaller set
        fprintf('scritto in %d\n', idx_a)
    end
end
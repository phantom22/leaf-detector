function analyze_correlation(co)
    N = size(co, 1);

    labels = arrayfun(@(x) ['(',num2str(x),')'], 1:N, 'UniformOutput', false)';
    
    mapping = containers.Map(1:N, labels);
    
    equiv_class = {};
    strong = {};
    weak = {};
    
    for i=1:N
        for j=i+1:N
            v = abs(co(i,j));
            if v >= 0.99
                equiv_class = add_set(equiv_class, i, j);
            elseif v >= 0.8
                strong = add_set(strong, i, j);
            elseif v >= 0.6
                weak = add_set(weak, i, j);
            end
        end
    end
    
    print_set(equiv_class, mapping, 'equivalence classes');
    print_set(strong, mapping, 'strong correlation');
    print_set(weak, mapping, 'weak correlation');
    
    no_equiv = remaining_partition(equiv_class, N);
    no_relations = {};
    for i=1:N
        if find_set(equiv_class, i) || find_set(strong, i) || find_set(weak, i)
            continue;
        end

        if isempty(no_relations)
            no_relations = {{}};
        end

        no_relations{1}{end+1} = i;

    end
    
    print_set(no_equiv, mapping, 'no equivalence classes');
    print_set(no_relations, mapping, 'very good features');
end
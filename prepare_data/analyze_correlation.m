function analyze_correlation(co)
    
    labels = {
        '(1)''major axis''';
        '(2)''minor axis''';
        '(3)''area''';
        '(4)''perimeter''';
        '(5)''aspect ratio''';
        '(6)''perimeter ratio of major axis''';
        '(7)''perimeter ratio of major axis and width''';
        '(8)''perimeter convexity''';
        '(9)''eccentricity''';
        '(10)''circularity''';
        '(11)''solidity''';
        '(12)''GLCM variance''';
        '(13)''GLCM contrast''';
        '(14)''GLCM uniformity''';
        '(15)''GLCM homogeneity''';
        '(16)''GLCM entropy''';
        '(17)''HIST uniformity''';
    };
    
    num_features = length(labels);
    
    mapping = containers.Map(1:num_features, labels);
    
    N = size(co, 1);
    
    equiv_class = {};
    strong = {};
    weak = {};
    
    for i=1:N
        for j=i+1:N
            v = abs(co(i,j));
            if v >= 0.9
                %disp('classi equivalenze');
                equiv_class = add_set(equiv_class, i, j);
            elseif v >= 0.8
                %disp('legame forte');
                strong = add_set(strong, i, j);
            elseif v >= 0.7
                %disp('legame debole');
                weak = add_set(weak, i, j);
            end
        end
    end
    
    x = remap_set(equiv_class, mapping, 'equivalence classes');
    fprintf('\n');
    y = remap_set(strong, mapping, 'strong correlation');
    fprintf('\n');
    z = remap_set(weak, mapping, 'weak correlation');
    fprintf('\n');
    
    no_equiv = remaining_partition(equiv_class, num_features);
    no_strong = remaining_partition(strong, num_features);
    no_weak = remaining_partition(weak, num_features);
    
    w = remap_set(no_equiv, mapping, 'no equivalence classes');
    fprintf('\n');
    a = remap_set(no_strong, mapping, 'no strong correlation');
    fprintf('\n');
    b = remap_set(no_weak, mapping, 'mo weak correlation');
    fprintf('\n');
end
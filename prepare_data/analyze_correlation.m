load('corr.mat', 'z');

labels = {
    '(1)''major axis''';
    '(2)''minor axis''';
    '(3)''area''';
    '(4)''perimeter''';
    '(5)''eccentricity''';
    '(6)''aspect ratio''';
    '(7)''circularity''';
    '(8)''compactness''';
    '(9)''rectangularity''';
    '(10)''perimeter ratio of major axis''';
    '(11)''perimeter ratio of major axis and width''';
    '(12)''perimeter convexity''';
    '(13)''area convexity''';
    '(14)''area ratio of convexity''';
    '(15)''equivalent diameter''';
    '(16)''GLCM variance''';
    '(17)''GLCM contrast''';
    '(18)''GLCM uniformity''';
    '(19)''GLCM homogeneity''';
    '(20)''GLCM entropy''';
    '(21)''HIST uniformity''';
    '(22)''HIST entropy''';
};

num_features = length(labels);

mapping = containers.Map(1:num_features, labels);

N = size(z, 1);

equiv_class = {};
strong = {};
weak = {};

for i=1:N
    for j=i+1:N
        v = abs(z(i,j));
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


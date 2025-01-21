%function mainall

    close all;

    gt={"G","G","G",...
        "D","D","D","D","D","D",...
        "E","E","E","E",...
        "I","I","I",...
        "N","N","N",...
        "L","L","L",...
        "M","M","M","M",...
        "F","F",...
        "A","A","A",...
        "B","B","B",...
        "C","C","C"};

    [num_images, class_full_paths, class_im_names] = image_paths_from_dir("images/Z");

    [m,n] = calcola_ingombro_minimo_subplot(num_images);

    dummy_se = strel('disk', 0);
    se = strel('disk', 3);

    figure_maximized;

    for i=1:num_images
        im = im2double(imread(class_full_paths{i}));

        f = sqrt(size(im,1) * size(im,2) / 120000);

        im = imresize(im, size(im,1:2) / f);

        mask = segment(im, se);
        classificato = classify(im, mask, dummy_se);

        % figure_maximized;
        % tsubplot(1,3,1); timshow(og_mask, 'segmented');
        % tsubplot(1,3,2); timshow(mask, 'cleaned');
        % tsubplot(1,3,3); timagesc(classificato, 'classified');

        tsubplot(m,n,i);
        visualize_classification(classificato);
        visualizzaClassi(classificato), title(gt(i));
    end
%end





%
%  M/d * N/d = 300 * 400
%  (M*N)/d^2 = 300*400
%  (M*N)/(300*400) = d^2
%  sqrt((M*N)/(300*400)) = d

function test_pixelmodel(class_folders, morphology, display)
    arguments
        class_folders = ["A","B","C","D","E","F","G","H","I","L","M","N"];
        morphology = [0,0];
        display = 1;
    end

    pixel_classifier = load_pixel_classifier();
    %load('models\bigger-pixel-classifier.mat','pixel_classifier');
    %pixel_classifier = classificatorB; 
        
    close all;
    
    num_classes = length(class_folders);
    
    % ["images\A", "images\B", ...]
    input_dirs = strcat('images\', class_folders); 
    % ["images\ground_truth\A", "images\ground_truth\B", ...]
    gt_dirs = strcat('images\ground_truth\', class_folders); 
    
    do_morphology = sum(morphology) ~= 0;
    if do_morphology
        see = strel('disk', morphology(1)); 
        sed = strel('disk', morphology(2));
        fprintf("[morphology: disk erode r=%d, disk dilate r=%d]\n", morphology);
    else
        fprintf("[no morphology]\n");
    end
    
    [class_num_images, class_full_paths, class_im_names] = image_paths_from_dir(input_dirs);
    [gt_num_images, gt_full_paths, ~] = image_paths_from_dir(gt_dirs);

    %disp(gt_num_images - class_num_images);
    
    tot_num_images = sum(gt_num_images);
    
    errori = cell(tot_num_images,3);
    
    pos = 1;
    
    ground_truth_nnz = zeros(tot_num_images,1);
    
    tic;
    for i=1:num_classes
        num_images = gt_num_images(i);
    
        if display
            ax_positions = get_minimal_grid(num_images);
            figure_maximized(input_dirs(i)," GIALLO=fn=1 BLU=fp=-1");
            p = 1;
        end
    
        for k=1:num_images
            if num_classes == 1
                im_path = class_full_paths{k};
                gt_path = gt_full_paths{k};
            else
                im_path = class_full_paths{i}{k};
                gt_path = gt_full_paths{i}{k};
            end
    
            im = im2double(imread(im_path));
            gt = imread(gt_path) > 1; % 1 perché con zero crea artefatti.
            ground_truth_nnz(pos) = nnz(gt);
    
            descriptors = pixel_descriptors(im);
            
            P = pixel_classifier.predictFcn(descriptors);
            labels = reshape(P, 300, 400);
            
            % cleanup dei label
            if do_morphology
                labels = imerode(labels,see);
                labels = imdilate(labels,sed);
                [regioni,~] = bwlabel(labels);
                areas = regionprops(regioni, "Area");
                areas = [areas.Area];
                [~,inx] = max(areas);
                labels = regioni==inx;
            end
    
            [falsi_positivi, falsi_negativi] = compute_seg_error(labels, gt);
    
            errori{pos,1} = im_path;
            errori{pos,2} = falsi_positivi;
            errori{pos,3} = falsi_negativi;
    
            if display
                subplot('Position',ax_positions(:,p));
                imagesc(gt - labels);
                axis image;
                axis off;
    
                if num_classes == 1
                    title(strcat(class_folders(i),"/",class_im_names{k}));
                else
                    title(strcat(class_folders(i),"/",class_im_names{i}{k}));
                end
    
                p = p + 1;
            end
            pos = pos + 1;
        end
        elapsed = toc;
        fprintf("'%s' done (elapsed: %.0fs, ETA: %.0fs).\n", input_dirs(i), round(elapsed), abs(round(elapsed/(pos-1)*(tot_num_images - pos + 1))));
    end
    
    falsi_positivi = cell2mat(errori(:,2));
    falsi_negativi = cell2mat(errori(:,3));
    errori_complessivi = falsi_negativi+falsi_positivi;
    errori_complessivi_pct = (errori_complessivi ./ ground_truth_nnz) * 100;
    [v_pegg,idx_pegg] = sort(errori_complessivi_pct, 'descend');
    [v_migl,idx_migl] = sort(errori_complessivi_pct, 'ascend');
    num_romani = {'I','II','III','IV','V','VI','VII','VIII','IX','X'};
    tot_output = min(10, length(v_pegg));
    
    for p=tot_output:-1:1
        pegg = idx_pegg(p);
        migl = idx_migl(p);
        fprintf("[%s posto]\n  pegg '%s': %.2f%% errori (fp:%d,fn:%d,gt:%d).\n  migl '%s': %.2f%% errori (fp:%d,fn:%d,gt:%d).\n", ...
            num_romani{p}, ...
            errori{pegg,1}, ...
            v_pegg(p), ...
            falsi_positivi(pegg), ...
            falsi_negativi(pegg), ...
            ground_truth_nnz(pegg), ...
            errori{migl,1}, ...
            v_migl(p), ...
            falsi_positivi(migl), ...
            falsi_negativi(migl), ...
            ground_truth_nnz(migl) ...
        );
    end
    
    tot_gt = 100 / sum(ground_truth_nnz);
    fprintf("[Errore medio: %.2f%%, Falso positivo: %.2f%%, Falso negativo: %.2f%%]\n", ...
        sum(errori_complessivi) * tot_gt, ...
        sum(falsi_positivi) * tot_gt, ...
        sum(falsi_negativi) * tot_gt);
end
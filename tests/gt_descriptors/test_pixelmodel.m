function test_pixelmodel(class_folders, morphology, display)
    arguments
        class_folders = ["A","B","C","D","E","F","G","H","I","L","M","N"];
        morphology {mustBePositive, mustBeInteger} = 5;
        display = 1;
    end
        
    close all;
    
    num_classes = length(class_folders);
    
    % ["images\A", "images\B", ...]
    input_dirs = strcat('images\', class_folders); 
    % ["images\ground_truth\A", "images\ground_truth\B", ...]
    gt_dirs = strcat('images\ground_truth\', class_folders); 

    [~, class_full_paths, class_im_names] = image_paths_from_dir(input_dirs);
    [gt_num_images, gt_full_paths, ~] = image_paths_from_dir(gt_dirs);
    
    tot_num_images = sum(gt_num_images);
    
    se = strel('disk', morphology); 
    fprintf("[morphology: disk r=%d, %d images]\n", morphology, tot_num_images);
    
    errori = cell(tot_num_images,5);
    
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

            labels = segment(im,se);
    
            [veri_positivi, veri_negativi, falsi_positivi, falsi_negativi] = compute_seg_error(labels, gt);
    
            errori{pos,1} = im_path;
            errori{pos,2} = veri_positivi;
            errori{pos,3} = veri_negativi;
            errori{pos,4} = falsi_positivi;
            errori{pos,5} = falsi_negativi;
    
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
    
    veri_positivi = cell2mat(errori(:,2));
    veri_negativi = cell2mat(errori(:,3));
    falsi_positivi = cell2mat(errori(:,4));
    falsi_negativi = cell2mat(errori(:,5));

    giusti_complessivi = veri_positivi+veri_negativi;
    errori_complessivi = falsi_negativi+falsi_positivi;

    area_im = 300*400;

    accuratezza_pct = (giusti_complessivi ./ area_im) * 100;
    errore_pct = (errori_complessivi ./ area_im) * 100;
    errore_foglia_pct = (errori_complessivi ./ ground_truth_nnz) * 100;

    [v_pegg,idx_pegg] = sort(errore_pct, 'descend');
    [v_migl,idx_migl] = sort(errore_pct, 'ascend');
    num_romani = {'I','II','III','IV','V','VI','VII','VIII','IX','X'};
    tot_output = min(10, length(v_pegg));
    
    for p=tot_output:-1:1
        pegg = idx_pegg(p);
        migl = idx_migl(p);
        fprintf("[%s posto]\n" + ...
                "  pegg '%s': %.2f%% errori (acc:%.2f%%,erf:%.2f%%,tp:%d,tn:%d,fp:%d,fn:%d,gt:%d).\n" + ...
                "  migl '%s': %.2f%% errori (acc:%.2f%%,erf:%.2f%%,tp:%d,tn:%d,fp:%d,fn:%d,gt:%d).\n", ...
            num_romani{p}, ...
            errori{pegg,1}, ...
            v_pegg(p), ...
            accuratezza_pct(pegg), ...
            errore_foglia_pct(pegg), ...
            veri_positivi(pegg), ...
            veri_negativi(pegg), ...
            falsi_positivi(pegg), ...
            falsi_negativi(pegg), ...
            ground_truth_nnz(pegg), ...
            errori{migl,1}, ...
            v_migl(p), ...
            accuratezza_pct(migl), ...
            errore_foglia_pct(migl), ...
            veri_positivi(migl), ...
            veri_negativi(migl), ...
            falsi_positivi(migl), ...
            falsi_negativi(migl), ...
            ground_truth_nnz(migl) ...
        );
    end
    
    inv_tot_area = 100 / (tot_num_images * area_im);
    inv_tot_gt = 100 / sum(ground_truth_nnz);
    fprintf("[Accuratezza media: %.2f%%, Errore medio: %.2f%%, Errore foglia medio: %.2f%%, Falso positivo: %.2f%%, Falso negativo: %.2f%%]\n", ...
        sum(giusti_complessivi) * inv_tot_area, ...
        sum(errori_complessivi) * inv_tot_area, ...
        sum(errori_complessivi) * inv_tot_gt, ...
        sum(falsi_positivi) * inv_tot_area, ...
        sum(falsi_negativi) * inv_tot_area);
end
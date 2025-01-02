function get_errors(class_folders, morphology, display, save)
    % get_errors(class_folders, [erode_radius, dilate_radius] = [2,1], display=1)
    %
    % es. per testare una sola classe:
    %   get_errors("A");
    %
    % es. per testare più classi con erode di r=3 e dilate di r=2
    %   get_errors(["A","B","D"], [3,2]);
    %
    % es. per non usare morfologia
    %   get_errors("M", [0,0]);
    %
    % es. per farlo su tutte le classi
    %   get_errors;
    arguments
        class_folders {mustBeText} = ["A","B","C","D","E","F","G","H","I","L","M","N"];
        morphology {mustBeNonnegative} = [2,1];
        display = 1;
        save=false;
    end
    
    close all;
    
    num_classes = length(class_folders);
    
    % ["images\A", "images\B", ...]
    input_dirs = strcat('images\', class_folders); 
    % ["images\ground_truth\A", "images\ground_truth\B", ...]
    gt_dirs = strcat('images\ground_truth\', class_folders); 
    
    if save
        save_dirs=strcat('images\segmented\', class_folders); 
        for i = 1:length(save_dirs)
            if ~exist(save_dirs(i), 'dir')
                 mkdir(save_dirs(i));
            end
        end
    end
    desired_superpixel_size = 5;
    % per adesso è hard-coded la dimensione dell'immagine aspettata (300x400)
    num_superpixels = ceil(300*400 / (desired_superpixel_size ^ 2));
    
    fprintf("[num_superpixels: %d]\n", num_superpixels);

    do_morphology = sum(morphology) ~= 0;
    
    if do_morphology
        see = strel('disk', morphology(1)); 
        sed = strel('disk', morphology(2));
        fprintf("[morphology: disk erode r=%d, disk dilate r=%d]\n", morphology);
    else
        fprintf("[no morphology]\n");
    end
    
    [class_num_images, class_full_paths, class_im_names] = image_paths_from_dir(input_dirs);
    [~, gt_full_paths, image_name] = image_paths_from_dir(gt_dirs);
    
    tot_num_images = sum(class_num_images);
    
    errori = cell(tot_num_images,3);
    
    pos = 1;
    
    ground_truth_nnz = zeros(tot_num_images,1);

    tic;
    for i=1:num_classes
        num_images = class_num_images(i);
    
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
            ground_truth = imread(gt_path) > 1; % 1 perché con zero crea artefatti.
            ground_truth_nnz(pos) = nnz(ground_truth);
            
            labels = extract_labels(im, num_superpixels);
            
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

            if save
                nomeImmagine=image_name{i};
                nomeImmagine=strsplit(char(nomeImmagine(k)),'.');
                imwrite(im.*labels, strcat(save_dirs(i),"\",nomeImmagine{1},".jpg"));
            end
    
            [falsi_positivi, falsi_negativi] = compute_seg_error(labels, ground_truth);
    
            errori{pos,1} = im_path;
            errori{pos,2} = falsi_positivi;
            errori{pos,3} = falsi_negativi;
    
            if display
                subplot('Position',ax_positions(:,p));
                imagesc(ground_truth - labels);
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
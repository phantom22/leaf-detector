close all;

tic;

class_folders = ["A","B","C","D","E","F","G","H","I","L","M","N"];
num_classes = length(class_folders);

% ["images\A", "images\B", ...]
input_dirs = strcat('images\', class_folders); 
% ["images\ground_truth\A", "images\ground_truth\B", ...]
gt_dirs = strcat('images\ground_truth\', class_folders); 

desired_superpixel_size = 5;
% per adesso è hard-coded la dimensione dell'immagine aspettata (300x400)
num_superpixels = ceil(300*400 / (desired_superpixel_size ^ 2));

fprintf("[num_superpixels: %d]\n", num_superpixels);

display = 1;

%profile on;

[class_num_images, class_full_paths, class_im_names] = image_paths_from_dir(input_dirs);
[~, gt_full_paths, ~] = image_paths_from_dir(gt_dirs);

tot_num_images = sum(class_num_images);

errori = cell(tot_num_images,3);

pos = 1;

ground_truth_nnz = zeros(tot_num_images,1);

for i=1:num_classes
    num_images = class_num_images(i);
    
    if display
        [m,n] = calcola_ingombro_minimo_subplot(num_images);
        fig = figure;
        set(fig, 'WindowState', 'maximized');
        set(fig, 'Name', input_dirs(i));
        p = 1;
    end

    for k=1:num_images
        im_path = class_full_paths{i}{k};
        gt_path = gt_full_paths{i}{k};

        im = im2double(imread(im_path));
        ground_truth = imread(gt_path) >= 50;
        ground_truth_nnz(pos) = nnz(ground_truth);
        
        desc = extract_slic_descriptors(im, num_superpixels, 18);
        labels = slic_spectral_clustering(im, desc, 2, false, false);

        labels = labels-1;
        [falsi_positivi, falsi_negativi, invertiti] = calcola_errore(labels, ground_truth);
        errori{pos,1} = im_path;
        errori{pos,2} = falsi_positivi;
        errori{pos,3} = falsi_negativi;

        if invertiti
            labels = 1-labels;
        end

        if display
            subplot(m,n,p);
            imagesc(ground_truth - labels);
            colorbar;
            title(class_im_names{i}{k});

            p = p + 1;
        end
        pos = pos + 1;
    end
    fprintf("'%s' done.\n", input_dirs(i));
end

falsi_positivi = cell2mat(errori(:,2));
falsi_negativi = cell2mat(errori(:,3));
errori_complessivi = falsi_negativi+falsi_positivi;
errori_complessivi_pct = (errori_complessivi ./ ground_truth_nnz) * 100;
[v_pegg,idx_pegg] = sort(errori_complessivi_pct, 'descend');
[v_migl,idx_migl] = sort(errori_complessivi_pct, 'ascend');
num_romani = {'I','II','III','IV','V','VI','VII','VIII','IX','X'};
tot_output = min(10,length(v_pegg));

for p=tot_output:-1:1
    pegg = idx_pegg(p);
    migl = idx_migl(p);
    fprintf("[%s posto]\n  pegg '%s': %.2f%% errori (fp:%d,fn:%d,gt:%d).\n  migl '%s': %.2f%% error (fp:%d,fn:%d,gt:%d).\n", ...
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

fprintf("[Errore medio: %.2f%%]\n", sum(errori_complessivi) / sum(ground_truth_nnz) * 100);

toc;
% profile off;
% profile viewer;

function test_pixel_base
    class_folders = ["A","B","C","D","E","F","G","H","I","L","M","N"];
     num_classes = length(class_folders);
    
    % ["images\A", "images\B", ...]
    input_dirs = strcat('images\', class_folders); 
    % ["images\ground_truth\A", "images\ground_truth\B", ...]
    gt_dirs = strcat('images\ground_truth\', class_folders); 
    [class_num_images, class_full_paths, class_im_names] = image_paths_from_dir(input_dirs);
    [~, gt_full_paths, image_name] = image_paths_from_dir(gt_dirs);
    
    tot_num_images = sum(class_num_images);
   
    pos = 0;
    num_feature=13;
    data=zeros(tot_num_images*300*400,num_feature,"single");
    tic;
    for i=1:num_classes
        num_images = class_num_images(i);

        for k=1:num_images
            if num_classes == 1
                im_path = class_full_paths{k};
                gt_path = gt_full_paths{k};
            else
                im_path = class_full_paths{i}{k};
                gt_path = gt_full_paths{i}{k};
            end
    
            im = im2double(imread(im_path));
            [m,n,~]=size(im);
            ground_truth = imread(gt_path) > 1; % 1 perché con zero crea artefatti.
            feature=zeros(m*n,num_feature);
            imycbcr=rgb2ycbcr(im);
            im_gray=im2gray(im);
            law=compute_laws_features(im_gray);
            
            feature(:,1:9)=reshape(law,m*n,9);
            g=imgradient(im_gray,"sobel");
            feature(:,10)=g(:);
            cb=imycbcr(:,:,2);
            feature(:,11)=cb(:);
            cr=imycbcr(:,:,3);
            feature(:,12)=cr(:);
            feature(:,13)=ground_truth(:).*i;
            data(pos*(m*n)+1:(pos+1)*(m*n),:)=feature;
            pos=pos+1;
        end
        elapsed = toc;
        fprintf("'%s' done (elapsed: %.0fs, ETA: %.0fs).\n", input_dirs(i), round(elapsed), abs(round(elapsed/(pos-1)*(tot_num_images - pos + 1))));
    end
    save("feature.mat","data");
end



from=["A","B","C","D","E","F","G","H","I","L","M","N"];
dir_im="images\";
dir_ground_truth="images\ground_truth";
desired_superpixel_size = 7;
display=1;

%profile on;
errori={};
pos=1;

for i=1:length(from)
    images = dir(fullfile("images",from(i), '*.jpg'));
    images = images(~[images.isdir]);
    num_images = length(images);
    if diplay==1
        [righe,colonne]= calcola_imgombro_minimo_subplot(num_images);
        fig=figure;
        set(fig, 'WindowState', 'maximized'); % Massimizza la finestra
        set(fig,"Name",from(i))
        pos_subplot=1;
    end
    for k=1:num_images
        im_name=fullfile(dir_im,from(i),images(k).name);
        im =  im2double(imread(im_name));
        ground_truth=imread(fullfile(dir_ground_truth,from(i),images(k).name))>=50;
        num_superpixels = ceil(size(im,1) * size(im,2) / (desired_superpixel_size ^ 2));
        desc = extract_slic_descriptors(im,num_superpixels, 18);
        labels=slic_spectral_clustering(im, desc, 2, false, false);
        labels=labels-1;
        [falsi_positivi, falsi_negativi,inverti]=calcola_errore(labels,ground_truth);
        errori{pos,1}=im_name;
        errori{pos,2}=falsi_positivi;
        errori{pos,3}=falsi_negativi;
        if inverti==1 
            labels=1-labels;
        end
        if display==1
                subplot(righe,colonne,pos_subplot),imagesc(ground_truth-labels),title(images(k).name),colorbar;
                pos_subplot=pos_subplot+1;
        end
        pos=pos+1;
    end
    fprintf("'%s' done.\n", from(i));
end
falsi_positivi=cell2mat(errori(:,2));
falsi_negativi=cell2mat(errori(:,3));
errori_complessivi=falsi_negativi+falsi_positivi;
[val,ind]=sort(errori_complessivi,"descend");
for p=1:min(10,length(val))
    fprintf("il %d peggiore è %s con %.2f%% ( %d,%d).\n",p,errori{ind(p),1},val(p)/1200,falsi_positivi(ind(p)),falsi_negativi(ind(p)));
end
% profile off;
% profile viewer;


from=["A","B","C","D","E","F","G","H","I","L","M","N"];
dir_im="images\";
dir_ground_truth="images\ground_truth";
profile on;
errori={};
pos=1;
for i=1:numel(from)
    images = dir(fullfile("images",from(i), '*.jpg'));
    images = images(~[images.isdir]);
    num_images = length(images);
    for k=1:num_images
        im_name=fullfile(dir_im,from(i),images(k).name);
        im =  im2double(imread(im_name));
        ground_truth=imread(fullfile(dir_ground_truth,from(i),images(k).name))>=50;
        imshow(ground_truth);
        desc = extract_slic_descriptors(im,4000, 18);
        labels=slic_spectral_clustering(im, desc, 2, false, false);
        labels=1-labels;
        [falsi_positivi, falsi_negativi]=calcola_errore(labels,ground_truth);
        errori{pos,1}=im_name;
        errori{pos,2}=falsi_positivi;
        errori{pos,3}=falsi_negativi;
        pos=pos+1;
    end
    fprintf("'%s' done.\n", from(i));
end
profile off;
profile viewer;

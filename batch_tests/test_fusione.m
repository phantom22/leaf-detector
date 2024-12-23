
from=["A","B","C","D","E","F","G","H","I","L","M","N"];
%from=["A","B"]
from=["G","I","L","M"];
profile on;
se = strel('disk', 5);  
ses = strel('square', 3);  
for i=1:numel(from)
    images = dir(fullfile("images",from(i), '*.jpg'));
    images = images(~[images.isdir]);
    num_images = length(images);
    [righe,colonne]= calcolaImgombroMinimoSubplot(num_images*2);
    fig=figure;
    set(fig, 'WindowState', 'maximized'); % Massimizza la finestra
    num=1;
    for k=1:num_images
        fname = fullfile("images",from(i),images(k).name);
        [filepath, name, ext] = fileparts(images(k).name);
        im =  im2double(imread(fname));
        [m,n,~]=size(im);
        imcmy=1-im;
        imc=imcmy(:,:,1);
        imm=imcmy(:,:,2);
        im4=imc.*imm;
        im2=rgb2ycbcr(im);
        im2=im2(:,:,2);
        imlab=rgb2lab(im);
        ima=imlab(:,:,2);
        img=im2gray(im);
        canali=zeros(m,n,7);
        canali(:,:,2)=ima;
        % canali(:,:,2)=img;
        canali(:,:,1)=edge(ima,"sobel");

        % canali(:,:,3:5)=im;
        % canali=normalize(canali,"norm");
        desc = seg_descriptors(im,4000, 18);
        labels=spectral_clustering(im, desc, 3, false, false);
        feature=extract_fusion_descriptors(max(max(labels)),labels,canali);
        Z = linkage(feature, 'ward'); % Perform hierarchical clustering
        T = cluster(Z, 'cutoff', 0.01, 'criterion', 'inconsistent'); % Merge clusters using a threshold
        finale=fondi_maschere(labels,T);
        

        subplot(righe,colonne,num),imagesc(finale),title(images(k).name), axis image, axis off;
        num=num+1;
        % subplot(righe,colonne,num),imagesc(finale),title(images(k).name), axis image, axis off;
        % num=num+1;
    end
    
end
profile off;
profile viewer;
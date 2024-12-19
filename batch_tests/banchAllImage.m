
from=["test"];
%from=["A","B","C","D","E","F","G","H","I","L","M","N"];

profile on;
se = strel('disk', 5);  
ses = strel('square', 10);  
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
          desc=zeros(m,n,3);
        desc(:,:,1)=ima;
        desc(:,:,2)=im2;
        desc(:,:,2)=im2gray(im);

         descn=normalize(im2single(desc),"norm");
        
        finale=imsegkmeans(im2single(desc),3);
        coloriMedi=zeros(3,1);
        img=im2gray(im);
        for label=1:3
            mask=finale==label;
            % mask=imclose(mask,ses);
            [y, x] = find(mask);
            
            % Calcola i limiti estremi
            xMin = min(x); % Coordinata minima lungo x
            xMax = max(x); % Coordinata massima lungo x
            yMin = min(y); % Coordinata minima lungo y
            yMax = max(y); % Coordinata massima lungo y
            % disp([images(k).name "," int2str(xMin) "," int2str(yMin) "," int2str(xMax - xMin + 1) "," int2str(yMax - yMin + 1)]);
            
            %coloriMedi(label)= sum(mask(:));
            coloriMedi(label)=xMax - xMin + 1+yMax - yMin + 1;
        end
        [coloriMedi,indici]=sort(coloriMedi);
         mask2=finale==indici(2);
       %  mask0=finale==2;
         mask1=finale==indici(1);
         mask3=finale==indici(3);
         finale2=uint8(mask1);
       % finale= watershed(img.*mask2);
       % finale2= watershed(img.*mask1);
        if(coloriMedi(2)-coloriMedi(1)<coloriMedi(1)*0.3)%coloriMedi(3)-coloriMedi(2))
            finale2=finale2+uint8(mask2);
        % else
        %     finale2=finale.*uint8(maskR)+indici(3).*uint8(mask2);
        end
        % mmin=im2<0.3;
        % mmax=im2>0.7;
        % im2=(0.7.*mmax)+(0.3.*mmin)+(im2.*(1-mmin-mmax));
        % desc = extract_slic_descriptors(im, 800, 15);
        % labels = kmeans(desc.descriptors, 2, 'MaxIter', 1000); % N_SP x 1
        % SP = desc.superpixels;
        % K = labels(SP); % riassegna ai superpixel le nuove labels date da kmeans
        %finale2=imclose(finale2,se);
        subplot(righe,colonne,num),imagesc(finale2),title(images(k).name), axis image, axis off;
        num=num+1;
        subplot(righe,colonne,num),imagesc(finale),title(images(k).name), axis image, axis off;
        num=num+1;
    end
    
end
profile off;
profile viewer;
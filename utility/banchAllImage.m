from=["A","B","C","D","E","F","G","H","I","L","M","N"];

profile on;
for i=1:numel(from)
    images = dir(fullfile("images",from(i), '*.jpg'));
    images = images(~[images.isdir]);
    num_images = length(images);
    [righe,colonne]= calcolaImgombroMinimoSubplot(num_images);
    figure;
    for k=3:num_images
        fname = fullfile("images",from(i),images(k).name);
        [filepath, name, ext] = fileparts(images(k).name);
        im =  imread(fname);
        im2=rgb2hsv(im);
        % desc = extract_slic_descriptors(im, 800, 15);
        % labels = kmeans(desc.descriptors, 2, 'MaxIter', 1000); % N_SP x 1
        % SP = desc.superpixels;
        % K = labels(SP); % riassegna ai superpixel le nuove labels date da kmeans
        subplot(righe,colonne,k-2),imagesc(im2(:,:,2)),colorbar, axis image, axis off;
    
    end
    
end
profile off;
profile viewer;
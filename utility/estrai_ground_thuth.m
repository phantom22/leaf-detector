function estrai_ground_thuth(from,to)
    images = dir(fullfile(from, '*.png'));
    images = images(~[images.isdir]);
    num_images = length(images);

   mkdir(to);
    
    for k=1:num_images
        [filepath, name, ext] = fileparts(images(k).name);
        im=im2gray(imread((fullfile(from,images(k).name))));
        imshow(im>0);
        imwrite(im>0,fullfile(to,strcat(name,".jpg")));
    end
end
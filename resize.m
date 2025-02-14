[num_images, full_paths, names] = image_paths_from_dir("images/test2");

target = "images/ground_truth/test2/";

figure_maximized;
[m,n] = calcola_ingombro_minimo_subplot(num_images);
for i=1:num_images
    im = im2single(imread(full_paths(i)));

    hsv = rgb2hsv(im);

    hv = hsv(:,:,2:3);

    tsubplot(m,n,i); imagesc(imsegkmeans(hv, 2)); axis image;

    %imwrite(hsv(hv,2), strcat(target,names(i)), 'jpg', 'Quality', 100);
end


function draw_slic(im, L, N)
    BW = boundarymask(L);
    
    t = figure;
    set(t, 'WindowState', 'maximized');
    % Overlay the superpixel boundaries on the original image
    imshow(imoverlay(im, BW, 'cyan'));
    title(['Superpixels Segmentation with ', num2str(N), ' Superpixels']);
end
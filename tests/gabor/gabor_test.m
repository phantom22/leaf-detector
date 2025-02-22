function createGaborFeatures
    K = 3;
    orientation = 0:45:315;
    omega = 4/sqrt(2);
    wavelength = [1 2] * omega;

    g = gabor(wavelength,orientation);
    sigmas = wavelength * K / 2;
    
    gabormag = imgaborfilt(im(:,:,3), gabor_filters);

    gcount = length(gabor_filters);

    [m,n] = calcola_ingombro_minimo_subplot(gcount);

    figure_maximized;
    for i = 1:gcount
        gabormag(:,:,i) = imgaussfilt(gabormag(:,:,i), gabor_sigmas(i));
        tsubplot(n,m,i);
        timagesc(gabormag(:,:,i), num2str(i));
    end

end

close all;

im = imread("images/Z/5.jpg");
im = imresize(im, [300 400]);

disp(size(im));

createGaborFeatures;

figure_maximized;
timshow(im);